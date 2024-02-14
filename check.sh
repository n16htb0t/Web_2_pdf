#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

url="$1"
remote_repo="https://github.com/n16htb0t/mainfile"  # Remote repository URL

run_nikto() {
    nikto_output=$(nikto -h "$url")
    echo "Nikto Output:" > output.txt
    echo "$nikto_output" >> output.txt
}

run_nuclei() {
    nuclei_output=$(nuclei -u "$url" -s critical,high,medium,low,info)
    echo -e "\n\nNuclei Output:" >> output.txt
    echo "$nuclei_output" >> output.txt
}

run_nikto &
run_nuclei &
wait

enscript -B -o output.ps output.txt

ps2pdf output.ps output.pdf

if [ ! -d "results" ]; then
    mkdir results
fi

timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
mv output.pdf "results/$1_output_${timestamp}.pdf"
echo "Output saved in results/output_${timestamp}_$1.pdf"

rm output.txt output.ps  # Deleting temporary text and PostScript files

# Add remote and pull updates
git remote add origin "$remote_repo"  # Add remote repository
git pull origin main  # Pull updates from the main branch

# Push results folder to GitHub
git add results
git commit -m "Added latest scan results for $1"
git push origin main  # Push changes to the main branch of the remote repository
