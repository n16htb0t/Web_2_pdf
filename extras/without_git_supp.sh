#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

url="$1"

run_nikto() {
    nikto_output=$(nikto -h "$url")
    echo "Nikto Output:" > output.txt
    echo "$nikto_output" >> output.txt
}

# Function to run Nuclei
run_nuclei() {
    nuclei_output=$(nuclei -u "$url" -s critical,high,medium,low,info)
    echo -e "\n\nNuclei Output:" >> output.txt
    echo "$nuclei_output" >> output.txt
}

# Run Nikto and Nuclei concurrently
run_nikto &
run_nuclei &
wait

enscript -B -o output.ps output.txt

# Convert PostScript file to PDF
ps2pdf output.ps output.pdf

# Check if results folder exists
if [ -d "results" ]; then
    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    mv output.pdf "results/$1_output_${timestamp}.pdf"
    echo "Output saved in results/$1_output_${timestamp}.pdf"
else
    mkdir results
    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    mv output.pdf "results/$1_output_${timestamp}.pdf"
    echo "Output saved in results/$1_output_${timestamp}.pdf"
fi

# Clean up temporary text and PostScript files
rm output.txt output.ps
