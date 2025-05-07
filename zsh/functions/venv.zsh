# Create and activate a virtual environment
function venv() {
  echo "Creating virtual environment in $(pwd)/.venv"
  python3 -m venv .venv --upgrade-deps
  source .venv/bin/activate
  
  # Add to git exclude
  if [[ -d .git ]]; then
    if ! grep -q "^.venv$" .git/info/exclude 2>/dev/null; then
      echo ".venv" >> .git/info/exclude
    fi
  fi
  
  # Time Machine exclusion (macOS only)
  tmutil addexclusion .venv
}
