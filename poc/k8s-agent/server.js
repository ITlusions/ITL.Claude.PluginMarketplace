// Minimal headless control API for the PoC agent. No dependencies.
//   GET  /healthz                      -> 200 ok (no auth)
//   POST /run {prompt, session_id?}    -> runs `claude -p`, returns its JSON result
// Auth: "Authorization: Bearer $CONTROL_TOKEN". One run at a time (429 when busy).
const http = require("http");
const { spawn } = require("child_process");
const crypto = require("crypto");

const TOKEN = process.env.CONTROL_TOKEN || "";
const PORT = parseInt(process.env.PORT || "8080", 10);
const TIMEOUT_MS = parseInt(process.env.RUN_TIMEOUT_SECONDS || "600", 10) * 1000;
// Unattended runs can't answer permission prompts, so only these tools are allowed.
const ALLOWED_TOOLS = process.env.ALLOWED_TOOLS || "Read,Glob,Grep";
const EXTRA_ARGS = (process.env.CLAUDE_ARGS || "").split(" ").filter(Boolean);
const MAX_BODY = 64 * 1024;

if (TOKEN.length < 16) {
  console.error("CONTROL_TOKEN must be set (>=16 chars). Refusing to start.");
  process.exit(1);
}

let busy = false;

const authorized = (req) => {
  const given = Buffer.from((req.headers.authorization || "").replace(/^Bearer /, ""));
  const want = Buffer.from(TOKEN);
  return given.length === want.length && crypto.timingSafeEqual(given, want);
};

const send = (res, code, body) => {
  res.writeHead(code, { "content-type": "application/json" });
  res.end(JSON.stringify(body));
};

function runClaude({ prompt, session_id }) {
  return new Promise((resolve) => {
    const args = ["-p", prompt, "--output-format", "json", "--allowedTools", ALLOWED_TOOLS, ...EXTRA_ARGS];
    if (session_id) args.push("--resume", session_id);
    const child = spawn("claude", args, { cwd: process.env.HOME + "/workspace", stdio: ["ignore", "pipe", "pipe"] });
    let out = "", err = "";
    const timer = setTimeout(() => child.kill("SIGKILL"), TIMEOUT_MS);
    child.stdout.on("data", (d) => (out += d));
    child.stderr.on("data", (d) => (err += d));
    child.on("close", (code) => {
      clearTimeout(timer);
      let result = null;
      try { result = JSON.parse(out); } catch { /* leave null, return raw */ }
      resolve({ exit_code: code, result, raw: result ? undefined : out, stderr: err.slice(-2000) });
    });
  });
}

http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/healthz") return send(res, 200, { ok: true, busy });
  if (!authorized(req)) return send(res, 401, { error: "unauthorized" });
  if (req.method !== "POST" || req.url !== "/run") return send(res, 404, { error: "not found" });

  let body = "";
  req.on("data", (d) => {
    body += d;
    if (body.length > MAX_BODY) { send(res, 413, { error: "body too large" }); req.destroy(); }
  });
  req.on("end", async () => {
    let parsed;
    try { parsed = JSON.parse(body); } catch { return send(res, 400, { error: "invalid json" }); }
    if (typeof parsed.prompt !== "string" || !parsed.prompt) return send(res, 400, { error: "prompt required" });
    if (busy) return send(res, 429, { error: "agent busy" });
    busy = true;
    try { send(res, 200, await runClaude(parsed)); } finally { busy = false; }
  });
}).listen(PORT, () => console.log(`control API on :${PORT}`));
