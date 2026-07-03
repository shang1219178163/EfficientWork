#!/usr/bin/env bash

set -e

install_dir() {
  [ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.shorebird" || printf %s "${XDG_CONFIG_HOME}/shorebird"
}

add_shorebird_to_path() {
  # Add the Shorebird CLI to your PATH.
  echo "Adding Shorebird to your PATH"

  rc_files=("$HOME/.bashrc" "$HOME/.zshrc")
  for rc_file in ${rc_files[@]}; do
    if [[ -e "$rc_file" ]]; then
      found_rc_file=true
      echo "Updating $rc_file"
      echo "export PATH=\"$(install_dir)/bin:\$PATH\"" >>$rc_file
    fi
  done

  if [[ ! $found_rc_file ]]; then
    echo "Unable to determine shell type. Please add Shorebird to your PATH manually."
    echo "export PATH=\"$(install_dir)/bin:\$PATH\""
  fi
}

# Function to compare two major.minor.patch versions
# Returns:
#   0 - If version1 is equal to version2
#   1 - If version1 is older than version2
#   2 - If version1 is newer than version2
version_compare () {
  local version1=$1
  local version2=$2

  local major1=${version1%%.*}
  local minor1=${version1#*.}
  minor1=${minor1%%.*}
  local patch1=${version1##*.}

  local major2=${version2%%.*}
  local minor2=${version2#*.}
  minor2=${minor2%%.*}
  local patch2=${version2##*.}

  if [ "$major1" -lt "$major2" ]; then
    return 1
  elif [ "$major1" -gt "$major2" ]; then
    return 2
  else
    if [ "$minor1" -lt "$minor2" ]; then
      return 1
    elif [ "$minor1" -gt "$minor2" ]; then
      return 2
    else
      if [ "$patch1" -lt "$patch2" ]; then
        return 1
      elif [ "$patch1" -gt "$patch2" ]; then
        return 2
      else
        return 0
      fi
    fi
  fi
}

FORCE=false
if [[ "$*" == *"--force"* ]]; then
  FORCE=true
fi

# Test if Git is available on the Host
if ! hash git 2>/dev/null; then
  echo >&2 "Error: Unable to find git in your PATH."
  exit 1
fi

MIN_GIT_VERSION="2.25.1"
GIT_VERSION=$(git --version | awk '{print $3}')
set +e
version_compare "$MIN_GIT_VERSION" "$GIT_VERSION"
GIT_VERSION_COMPARISON=$?
set -e
if [ $GIT_VERSION_COMPARISON -eq 2 ]; then
  echo >&2 "Error: system git version ($GIT_VERSION) is older than required ($MIN_GIT_VERSION)."
  exit 1
fi

# Check if install_dir already exists
if [ -d "$(install_dir)" ]; then
  if [ "$FORCE" = true ]; then
    echo "Existing Shorebird installation detected. Overwriting..."
    rm -rf "$(install_dir)"
  else
    echo >&2 "Error: Existing Shorebird installation detected. Use --force to overwrite."
    exit 1
  fi
fi

# Clone the Shorebird repository into the install_dir
# 使用 ghproxy 代理加速 GitHub 克隆
echo "Cloning Shorebird into $(install_dir)"
git clone https://ghproxy.net/https://github.com/shorebirdtech/shorebird.git -b stable "$(install_dir)"

# Build Shorebird
(cd "$(install_dir)" && ./bin/shorebird --version)

RELOAD_REQUIRED=false
SHOREBIRD_BIN="$(install_dir)/bin"
case :$PATH: in *:$SHOREBIRD_BIN:*) ;; # do nothing, it's there
*)
  RELOAD_REQUIRED=true
  add_shorebird_to_path >&2
  ;;
esac

echo ""
echo "🐦 Shorebird has been installed!"

if [ "$RELOAD_REQUIRED" = true ]; then
  echo "
Close and reopen your terminal to start using Shorebird or run the following command to start using it now:

  export PATH=\"$(install_dir)/bin:\$PATH\""
fi

echo "
To create an account, visit: https://console.shorebird.dev
Then login using:

  shorebird login

For more information, visit:
https://docs.shorebird.dev
"
