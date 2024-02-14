#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

url="$1"

nikto_output=$(nikto -h "$url")
nuclei_output=$(nuclei -u "$url" -s critical,high,medium,low,info)

echo "Nikto Output:" > output.txt
echo "$nikto_output" >> output.txt
echo -e "\n\nNuclei Output:" >> output.txt
echo "$nuclei_output" >> output.txt

enscript -B -o output.ps output.txt

ps2pdf output.ps output.pdf

if [ -d "results" ]; then
    timestamp=$(date +%Y%m%d%H%M)
    mv output.pdf results/$1_output_${timestamp}.pdf
    echo "Output saved in results/output_${timestamp}_$i.pdf"

    cd results || exit
    git add .
    git commit -m "Updated results on $(date)"
    git pull origin main --rebase
    git push origin HEAD:main
    cd ..

else
    mkdir results
    timestamp=$(date +%Y%m%d%H%M%S)
    mv output.pdf results/$1_output_${timestamp}.pdf
    echo "Output saved in results/output_${timestamp}_$i.pdf"

    cd results || exit
    git init
    git remote add origin https://github.com/n16htb0t/mainfile.git
    git add .
    git commit -m "Initial commit"
    git push -u origin HEAD:main
    cd ..
fi

rm output.txt output.ps
