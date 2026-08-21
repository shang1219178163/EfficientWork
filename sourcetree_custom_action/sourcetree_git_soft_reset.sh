#!/usr/bin/env bash
# 把当前 HEAD 退回暂存区：git reset --soft HEAD~1
# 仅通过 SourceTree 右键自定义操作取值，不单独从终端传参。
# Parameters: $REPO $SHA
# 已推送仍要退回: $REPO $SHA --force
set -euo pipefail

usage() {
  cat <<'EOF'
SourceTree 自定义操作（在提交上右键）：
  Menu Caption:  退回提交到暂存区
  Parameters:    $REPO $SHA
  已推送仍要退回:  $REPO $SHA --force
EOF
}

[[ "${1:-}" == -h || "${1:-}" == --help ]] && { usage; exit 0; }

REPO=${1:-}
SHA=${2:-}
[[ -n "$REPO" && -n "$SHA" ]] || { usage; exit 2; }

FORCE=0
shift 2
for a in "$@"; do
  case "$a" in
    -f|--force) FORCE=1 ;;
    *) usage; exit 2 ;;
  esac
done

cd "$REPO"
git rev-parse --is-inside-work-tree >/dev/null

HEAD=$(git rev-parse HEAD)
TARGET=$(git rev-parse --verify "$SHA^{commit}")
[[ "$HEAD" == "$TARGET" ]] || { echo "只能退回 HEAD"$'\n'"HEAD: $HEAD"$'\n'"选中: $TARGET" >&2; exit 1; }
git rev-parse --verify --quiet HEAD^ >/dev/null || { echo "无法退回仓库的第一个提交" >&2; exit 1; }

on_remote() {
  git merge-base --is-ancestor HEAD '@{u}' 2>/dev/null && return 0
  local b r
  b=$(git symbolic-ref --short -q HEAD) || return 1
  for r in $(git remote); do
    git merge-base --is-ancestor HEAD "refs/remotes/$r/$b" 2>/dev/null && return 0
  done
  return 1
}

if on_remote && (( FORCE == 0 )); then
  echo "该提交已在远端。把 Parameters 改成 \$REPO \$SHA --force 只改本地，不同步远端。" >&2
  exit 1
fi

git reset --soft HEAD~1
echo "已退回暂存区: $TARGET  $(git log -1 --format=%s "$TARGET")"
git status -s
