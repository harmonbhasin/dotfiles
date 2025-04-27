function scrape
    set -q FIRECRAWL_API_KEY; or begin
        echo "Error: FIRECRAWL_API_KEY environment variable is not set"
        return 1
    end

    # Check if URL is provided
    if test (count $argv) -lt 1
        echo "Usage: scrape <url> [output_file]"
        echo "Example: scrape https://example.com output.md"
        echo "If no output file is specified, output will be printed to stdout"
        return 1
    end

    set url $argv[1]
    
   # Create a JSON payload file for better handling of quotes
    set tempfile (mktemp)
    echo '{
        "url": "'$url'",
        "formats": ["markdown"],
        "onlyMainContent": true,
        "waitFor": 0,
        "mobile": false,
        "skipTlsVerification": false,
        "timeout": 30000,
        "location": {
            "country": "US"
        },
        "blockAds": true
    }' > $tempfile
    
    # Execute curl with properly quoted headers and data from file
    set -l api_response (curl -s -X POST "https://api.firecrawl.dev/v1/scrape" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
        --data @$tempfile)
        
    # Clean up the temp file
    rm $tempfile
    
    # Parse the response to check for success and extract markdown
    # First check if the response contains "success": true
    if echo $api_response | grep -q '"success": *true'
        # Extract just the markdown content
        set -l markdown (echo $api_response | jq -r '.data.markdown')
        
        # If output file is specified, save markdown to that file
        if test (count $argv) -gt 1
            echo $markdown > $argv[2]
            echo "Content from $url saved to $argv[2]"
        else
            # Otherwise, output markdown to stdout
            echo $markdown
        end
    else
        # If not successful, print error
        echo "Error: Failed to crawl $url"
        echo $api_response
        return 1
    end
end
