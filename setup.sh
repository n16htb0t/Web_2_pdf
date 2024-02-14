#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <Sudo password>"
    exit 1
fi

echo $1 | sudo -S apt install -y enscript nikto docker.io python3 python3-pip 
pip install flask
docker run -it --rm projectdiscovery/nuclei:latest nuclei -h
chmod +x check.sh
python3 ./app.py

