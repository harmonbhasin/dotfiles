repos() {
  gh repo list --limit 10 --json nameWithOwner,url --jq '.[] | "\(.nameWithOwner)\t\(.url)"'
}
