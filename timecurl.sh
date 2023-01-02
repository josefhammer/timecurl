#!/bin/bash
#
# Measure HTTP request/response times using Curl.
# (c) 2022 Josef Hammer (josefhammer.com) -- MIT License
#
# Source: https://github.com/josefhammer/timecurl


# man curl:
#
# __time_namelookup__
# The time, in seconds, it took from the start until the name resolving was completed.
#
# __time_connect__   
# The time, in seconds, it took from the start until the TCP connect to the remote host (or proxy) was completed.
#
# __time_appconnect__
# The time, in seconds, it took from the start until the SSL/SSH/etc connect/handshake to the remote host was completed. (Added in 7.19.0)
#
# __time_pretransfer__
# The time, in seconds, it took from the start until the file transfer was just about to begin. This includes all pre-transfer commands 
# and negotiations that are specific to the particular protocol(s) involved.
#
# __time_redirect__  
# The  time,  in seconds, it took for all redirection steps including name lookup, connect, pretransfer and transfer before the final
# transaction was started. time_redirect shows the complete execution time for multiple redirections. (Added in 7.12.3)
#
# __time_starttransfer__
# The time, in seconds, it took from the start until the first byte was just about to be transferred. This includes
# time_pretransfer and also the time the server needed to calculate the result.
#
# __time_total__
# The total time, in seconds, that the full operation lasted.
#
# __num_connects__   
# Number of new connects made in the recent transfer.
#
# __size_download__
# The total amount of bytes that were downloaded.
#
# __size_request__
# The total amount of bytes that were sent in the HTTP request.

NUM_REQUESTS=1
SLEEP=0
STDIN=0
ID=


# Parse command line params
#
while [[ $1 == "--loop" ]] || [[ $1 == "--sleep" ]] || [[ $1 == "--id" ]] || [[ $1 == "--stdin" ]]; do
    if [[ $1 == "--loop" ]]; then
        shift
        if [[ $1 -gt 1 ]]; then
            NUM_REQUESTS=$1
        fi
        shift
    fi
    if [[ $1 == "--sleep" ]]; then
        shift
        SLEEP=$1
        shift
    fi
    if [[ $1 == "--id" ]]; then
        shift
        ORIG_ID=$1
        ID=$1
        shift
    fi
    if [[ $1 == "--stdin" ]]; then  # Shall we read the URL(s) from STDIN?
        shift
        STDIN=1
    fi
done


# Help message for the options
#
if [[ $# -lt 1 ]] && [[ $STDIN -eq 0 ]]
then
    echo "Usage: $0 [--loop <numRequests>] [--sleep <numSeconds>] [--id <ID>] [--stdin] [<Curl options>] [<URL>]"
    echo "Pass '-L' for Curl to follow redirections."
    echo ""
    exit 1
fi


# Main loop
#
mainCurlLoop() {
    for ((i=1; i<=$NUM_REQUESTS; i++))
    do
        if [[ $i -gt 1 ]]; then 
            echo "},{"
            if [[ $SLEEP -gt 0 ]]; then
                sleep "$SLEEP"
            fi
        fi

        curl -s -o /dev/null -w @- "$@" <<'EOF'
            "remote":  "%{remote_ip}:%{remote_port}",\n
         "http_code":  %{http_code},\n
      "num_connects":  %{num_connects},\n
      "size_request":  %{size_request},\n
     "size_download":  %{size_download},\n
   "time_namelookup":  %{time_namelookup},\n
  "time_pretransfer":  %{time_pretransfer},\n
"time_starttransfer":  %{time_starttransfer},\n
\n
      "time_connect":  %{time_connect},\n
        "time_total":  %{time_total},\n
EOF
    echo "         \"exit_code\":  $?,"
    echo "                \"id\":  \"$ID\""
    done
}


# *** MAIN ***
#
echo "[{"

if [[ $STDIN -eq 0 ]]; then
    mainCurlLoop "$@"
else
    # read URLs from stdin (one per line; format: [<ID>] URL)
    #
    COUNTER=0
    while read -a ADDR; do 
        >&2 echo "# ${ADDR[@]}"  # print input on stderr for monitoring

        [[ $ADDR =~ ^#.* ]] && continue  # ignore comment lines starting with '#'

        COUNTER=$((COUNTER+1))

        if [[ $COUNTER -gt 1 ]]; then
            echo "},{"
        fi
        if [[ ${#ADDR[@]} -gt 1 ]]; then  # if two elements available: use first as ID
            ID="${ADDR[0]}"
            ADDR[0]=${ADDR[1]}
        else
            ID=$ORIG_ID
        fi
        mainCurlLoop "$@" ${ADDR[0]}
    done
fi

echo "}]"
