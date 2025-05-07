# Load environment variables from file
function envsource() {
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ ! "$line" =~ ^# && -n "$line" ]]; then
      key="${line%%=*}" 
      value="${line#*=}"
      export "$key"="$value"
      echo "Exported key $key"
    fi
  done < "$1"
}
