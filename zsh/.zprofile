if [ "$(uname -m)" = "x86_64" ]; then
  HOMEBREW_PREFIX="/usr/local"
else
  HOMEBREW_PREFIX="/opt/homebrew"
fi

if [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
  eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
fi
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
