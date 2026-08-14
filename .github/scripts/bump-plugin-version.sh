#!/usr/bin/env bash
# Computes and writes the next semver for one plugin, based on
# conventional-commit messages touching its directory since its last
# {plugin}--v{version} tag. A plugin with no tag yet keeps whatever version
# is currently committed as its v1 baseline.
#
# Usage: bump-plugin-version.sh <plugin-name>
# Run from the repo root, with the plugin's tags already fetched locally.
#
# Prints (stdout, one per line, key=value):
#   changed=true|false
#   version=X.Y.Z   (only if changed=true)
#   tag=name--vX.Y.Z (only if changed=true)
#
# Does NOT commit/tag/push — the caller does that, so it controls ordering
# when looping across multiple plugins in one job.

set -euo pipefail

name="$1"
dir="plugins/${name}/"
manifest="${dir}.claude-plugin/plugin.json"

if [ ! -f "$manifest" ]; then
  echo "::error::No plugin.json found for $name at $manifest" >&2
  exit 1
fi

latest_tag=$(git tag -l "${name}--v*" | sort -V | tail -n1 || true)

if [ -z "$latest_tag" ]; then
  new_version=$(node -p "require('./$manifest').version")
  echo "$name: no prior tag, baselining at $new_version" >&2
else
  if git diff --quiet "$latest_tag" -- "$dir"; then
    echo "$name: no changes since $latest_tag" >&2
    echo "changed=false"
    exit 0
  fi

  latest_version="${latest_tag##*--v}"
  bump=patch
  while IFS= read -r msg; do
    case "$msg" in
      *BREAKING\ CHANGE*) bump=major ;;
      *!:*) bump=major ;;
      feat:*|feat\(*) [ "$bump" = major ] || bump=minor ;;
    esac
  done < <(git log "${latest_tag}..HEAD" --pretty=%s -- "$dir")

  IFS=. read -r major minor patch <<< "$latest_version"
  case "$bump" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac
  new_version="${major}.${minor}.${patch}"
  echo "$name: $latest_version -> $new_version (bump: $bump)" >&2
fi

node -e "
  const fs = require('fs');
  const p = '$manifest';
  const j = JSON.parse(fs.readFileSync(p, 'utf8'));
  j.version = '$new_version';
  fs.writeFileSync(p, JSON.stringify(j, null, 2) + '\n');
"

echo "changed=true"
echo "version=$new_version"
echo "tag=${name}--v${new_version}"
