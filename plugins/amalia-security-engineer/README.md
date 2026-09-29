# Amalia Security Vulnerability Engineer Plugin

Comprehensive automated security vulnerability scanner with SAST, attack surface mapping, binary hardening analysis, memory safety scanning, exploitability assessment, ROP chain analysis, and full ITL Amalia threat intelligence platform integration.

## Components

### Agent: `amalia-security-engineer`

A comprehensive security scanning agent covering:

- **Source Code Analysis** — SAST engine with 42 detection rules across Python, JavaScript, C/C++
- **Attack Surface Mapping** — FastAPI/Flask/Django endpoint discovery, input vector analysis, auth boundary mapping
- **Binary Hardening** — Check ELF binaries for NX, PIE, canaries, RELRO, FORTIFY, CFI, CET protections
- **Memory Safety** — Detect buffer overflows, use-after-free, format strings, integer overflows, race conditions
- **Binary Analysis** — Full control flow graph (CFG) recovery, dangerous function detection, reachability analysis
- **ROP Chain Analysis** — Gadget discovery, chain building (set_regs, write_to_mem, execve, syscall), feasibility assessment
- **Exploitability Scoring** — Combine source vulnerabilities + binary hardening → risk score
- **Threat Intelligence** — Amalia CLI integration for OSINT, SIGINT, FININT, dark web, Shodan, ADS-B, AIS, GEOINT
- **Reporting** — Generate text, JSON, SARIF output formats
- **BrainCell Integration** — Store findings, decisions, and patterns for organizational memory

## Quick Start

```
@amalia-security-engineer Scan my src directory for vulnerabilities
@amalia-security-engineer Analyze attack surface of my FastAPI app
@amalia-security-engineer Compare hardening between two binaries
@amalia-security-engineer Generate ROP chain for this binary
@amalia-security-engineer Run threat scan via Amalia on this IP
@amalia-security-engineer Generate SARIF report for GitHub
```

## Scanner Capabilities

### 21 Security Tools

**Source Code Analysis:**
- `scan_directory_for_vulnerabilities` — Recursive SAST scan
- `scan_code_snippet` — Scan pasted code
- `check_memory_safety` — Memory safety issues
- `analyze_attack_surface` — Endpoint & input mapping
- `check_build_hardening` — Makefile/CMake/Docker hardening flags

**Binary Analysis:**
- `compile_c_source` — Compile with GCC (hardening on/off)
- `check_binary_hardening` — ELF hardening checks
- `compare_binary_hardening` — Side-by-side comparison
- `analyze_binary_with_angr` — Full CFG + reachability
- `analyze_binary` — Quick angr summary

**ROP Chain Analysis:**
- `rop_gadget_analysis` — Discover & categorize gadgets
- `rop_build_chain` — Build chains (set_regs, write_to_mem, execve, syscall)
- `rop_compare_feasibility` — Compare two binaries
- `exploit_generate` — Generate working exploit payload

**Assessment & Reporting:**
- `exploitability_assessment` — Risk scoring
- `compile_and_compare` — Full end-to-end pipeline
- `generate_full_report` — Complete scan with multiple formats

**BrainCell Memory:**
- `search_security_patterns` — Query organizational memory
- `store_security_finding` — Store findings
- `store_security_decision` — Store decisions
- `braincell_health` — Check connectivity

### 42 Detection Rules

**Python (18 rules):** SQL Injection, OS Command Injection, LDAP Injection, XSS, Insecure Deserialization, Hardcoded Secrets, SSRF, Path Traversal, Weak Crypto, Insecure Random, JWT Issues, CSRF, Sensitive Logging, Race Conditions, Unsafe eval/exec

**JavaScript (12 rules):** SQL Injection, DOM XSS, dangerouslySetInnerHTML, Insecure Deserialization, Hardcoded Secrets, Command Injection, SSRF, Path Traversal, Weak Crypto, Prototype Pollution, Permissive CORS, Unsafe eval

**C/C++ (10 rules):** gets() unbounded read, Unsafe strcpy/strcat/sprintf, Use-after-free, Double free, Integer overflow, Format string, Command injection, Non-cryptographic PRNG, Insecure temp files

**Generic (2 rules):** Security annotations (TODO/FIXME), Debug mode enabled

### Binary Hardening Checks

Detects: NX/DEP, PIE, Stack Canary, RELRO, Full RELRO, FORTIFY_SOURCE, CFI, CET

### angr Binary Analysis

- Control Flow Graph (CFG) recovery
- Dangerous call detection (gets, strcpy, system, sprintf)
- Reachability analysis
- Hardening symbol detection (__stack_chk_fail, __fortify_fail)

### angrop ROP Analysis

- Gadget discovery and categorization
- ROP chain building (set_regs, write_to_mem, execve, syscall)
- Feasibility ratings (TRIVIAL/FEASIBLE/DIFFICULT/INFEASIBLE)
- Side-by-side binary comparison
- Payload generation (hex dump + Python code)

## Amalia CLI Integration

Direct access to ITL Amalia threat intelligence platform:

**Threat Detection:** scan, investigate, monitor targets
**Vulnerability Scanning:** vulnscan with firmware unpacking
**MITRE ATT&CK:** Tactic/technique listing and search
**Infrastructure:** Shodan queries, dark web scanning
**Radio Intelligence:** WebSDR frequency scanning and monitoring
**Physical Tracking:** ADS-B (aircraft) and AIS (vessels) tracking
**Financial:** Blockchain/crypto wallet monitoring
**Other:** Satellite imagery, Telegram, audio analysis, WiFi sensing

All commands support `-j` / `--json-output` for machine-readable results.

## Standards Coverage

### OWASP Top 10
All 10 categories covered: Access Control, Cryptography, Injection, Insecure Design, Misconfiguration, Vulnerable Components, Auth Failures, Data Integrity, Logging, SSRF

### CWE Top 25
Comprehensive coverage of critical weaknesses including:
- CWE-78: OS Command Injection
- CWE-79: Cross-Site Scripting
- CWE-89: SQL Injection
- CWE-120: Buffer Overflow
- CWE-502: Insecure Deserialization
- CWE-798: Hardcoded Credentials

### MITRE ATT&CK
Map findings to tactics and techniques via Amalia integration

## Recommended Workflows

**Web App Security Review:** scan_directory → analyze_attack_surface → check_memory_safety → generate_full_report

**Binary Hardening:** compile (unhardened) → compile (hardened) → compare_binary_hardening → analyze_with_angr → exploitability_assessment

**ROP Analysis:** rop_gadget_analysis → rop_compare_feasibility → exploit_generate

**Threat Intelligence:** amalia scan → investigate → map to ATT&CK → store_security_finding

**Full Pipeline:** compile_and_compare (one command handles everything)

## ITL Control Plane Context

Specialized scanning for ITL Cloud Control Plane components:
- FastAPI API Gateway
- Python SDK packages
- Resource Providers
- IAM/Keycloak integration
- GraphDB metadata service
- Docker container configurations
- C/C++ native extensions

## Deliverables

- 📊 Vulnerability reports (text, JSON, SARIF)
- 🏆 Exploitability assessments with risk scores
- 🛡️ Hardening comparison tables
- 🔧 Compilation instructions (with/without hardening)
- 🎯 ROP chain payloads (hex + Python)
- 📈 Attack surface maps
- 🌐 Threat intelligence findings
- 💾 BrainCell-stored organizational knowledge

## Version

**1.0.0** - Initial migration from ITL.Agents Security Engineer custom agent

---

**Authored by**: Niels Weistra  
**Repository**: https://github.com/ITlusions/ITL.Claude.PluginMarketplace  
**License**: MIT
