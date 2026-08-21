#!/usr/bin/env bash
# 反向 apply 到工作区，不提交：git revert -n <sha>
# 仅通过 SourceTree 右键自定义操作取值，不单独从终端传参。
# Parameters: $REPO $SHA
# 合并提交:   $REPO $SHA --mainline 1
set -euo pipefail

usage() {
  cat <<'EOF'
SourceTree 自定义操作（在提交上右键）：
  Menu Caption:  反向应用到工作区(不提交)
  Parameters:    $REPO $SHA
  合并提交:       $REPO $SHA --mainline 1
EOF
}

[[ "${1:-}" == -h || "${1:-}" == --help ]] && { usage; exit 0; }

REPO=${1:-}
SHA=${2:-}
[[ -n "$REPO" && -n "$SHA" ]] || { usage; exit 2; }

MAINLINE=
shift 2
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mainline)
      MAINLINE=${2:-}
      [[ "$MAINLINE" =~ ^[0-9]+$ ]] || { echo "Parameters 里 --mainline 后必须跟正整数" >&2; exit 2; }
      shift 2
      ;;
    --mainline=*)
      MAINLINE=${1#--mainline=}
      [[ "$MAINLINE" =~ ^[0-9]+$ ]] || { echo "Parameters 里 --mainline 后必须跟正整数" >&2; exit 2; }
      shift
      ;;
    *) usage; exit 2 ;;
  esac
done

cd "$REPO"
git rev-parse --is-inside-work-tree >/dev/null
[[ -f "$(git rev-parse --git-path REVERT_HEAD)" ]] && { echo "已有进行中的 revert：git revert --abort 或处理完冲突。" >&2; exit 1; }

TARGET=$(git rev-parse --verify "$SHA^{commit}")
if git rev-parse --verify --quiet "${TARGET}^2" >/dev/null && [[ -z "$MAINLINE" ]]; then
  echo "合并提交必须指定 --mainline N（一般为 1）。SourceTree: \$REPO \$SHA --mainline 1" >&2
  exit 1
fi

opts=(--no-commit)
[[ -n "$MAINLINE" ]] && opts+=(-m "$MAINLINE")

if git revert "${opts[@]}" "$TARGET"; then
  git revert --quit 2>/dev/null || true
  echo "已反向应用到工作区（未提交）: $TARGET  $(git log -1 --format=%s "$TARGET")"
  git status -s
else
  echo "revert 失败（可能有冲突）。git revert --abort 放弃，或解决后自行提交。" >&2
  exit 1
fi
