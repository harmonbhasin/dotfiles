# Create and switch to a temporary directory
function tmpdir() {
  cd "$(mktemp -d)"
}
