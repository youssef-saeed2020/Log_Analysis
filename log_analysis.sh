#!/bin/bash

LOG_FILE="access.log"  # Replace with your log file path

# 1. Request Counts
total_requests=$(wc -l < "$LOG_FILE")
get_requests=$(grep '"GET' "$LOG_FILE" | wc -l)
post_requests=$(grep '"POST' "$LOG_FILE" | wc -l)

# 2. Failures (4xx or 5xx)
failures=$(awk '$9 ~ /^4|^5/' "$LOG_FILE" | wc -l)
failure_percent=$(awk -v f="$failures" -v t="$total_requests" 'BEGIN { printf "%.2f", (f/t)*100 }')

# 3. Requests by Hour
requests_by_hour=$(awk '{print $4}' "$LOG_FILE" | cut -d: -f2 | sort | uniq -c)

# 4. Status Code Breakdown
status_breakdown=$(awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr)

# Save data for Python visualization
echo "$total_requests,$get_requests,$post_requests,$failures,$failure_percent" > data.csv
echo "$requests_by_hour" >> data.csv
echo "$status_breakdown" >> data.csv

echo "==== Log File Analysis ===="
echo "Total Requests: $total_requests"
echo "GET Requests: $get_requests"
echo "POST Requests: $post_requests"
echo "Failures (4xx/5xx): $failures ($failure_percent%)"
echo "Requests by Hour: $requests_by_hour"
echo "Status Code Breakdown: $status_breakdown"

