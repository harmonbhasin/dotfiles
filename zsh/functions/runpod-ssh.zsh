#!/usr/bin/env zsh

runssh() {
    local pod_id="$1"
    
    if [[ -z "$pod_id" ]]; then
        echo "Usage: runssh <pod_id>"
        return 1
    fi
    
    if [[ -z "$RUNPOD_API_KEY" ]]; then
        echo "Error: RUNPOD_API_KEY environment variable not set"
        return 1
    fi
    
    # Query the RunPod API
    local response=$(curl -s --request POST \
        --header 'content-type: application/json' \
        --url "https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY}" \
        --data "{\"query\": \"query Pod { pod(input: {podId: \\\"${pod_id}\\\"}) { runtime { ports { ip isIpPublic privatePort publicPort type } } } }\"}")
    
    # Get the SSH port mapping (privatePort 22)
    local port_info=$(echo "$response" | jq -r '.data.pod.runtime.ports[] | select(.privatePort == 22) | "\(.ip) \(.publicPort)"')
    
    if [[ -z "$port_info" ]]; then
        echo "Error: Could not find port info for pod $pod_id"
        return 1
    fi
    
    local ip=$(echo "$port_info" | awk '{print $1}')
    local port=$(echo "$port_info" | awk '{print $2}')
    
    # Build SSH command - use the public IP and port
    local ssh_cmd="ssh root@${ip} -p ${port} -i ~/.ssh/id_ed25519"
    
    # Copy to clipboard
    echo -n "$ssh_cmd" | pbcopy
    
    echo "SSH command copied to clipboard:"
    echo "$ssh_cmd"
}
