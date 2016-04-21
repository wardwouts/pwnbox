#!/usr/bin/env bash

# Run superkojiman/pwnbox container in docker. 
# Store your .gdbinit, .radare2rc, .vimrc, etc in a ./rc directory. The contents will be copied to
# /root/ in the container.

ESC="\x1B["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

if [[ -z ${1} ]]; then
    echo -e "${RED}Missing argument CTF name.${RESET}"
    exit 0
fi

ctf_name=${1}

# Create docker container and run in the background
docker run -it \
    -d \
    -h ${ctf_name}-ctf \
    --security-opt seccomp:unconfined \
    --name ${ctf_name}-ctf \
    superkojiman/pwnbox

# Tar config files in rc and extract it into the container
if [[ -d rc ]]; then
    cd rc
    if [[ -f rc.tar ]]; then
        rm -f rc.tar
    fi
    for i in .* *; do
        if [[ ! ${i} == "." && ! ${i} == ".." ]]; then
            tar rf rc.tar ${i}
        fi
    done
    cd - > /dev/null 2>&1
    cat rc/rc.tar | docker cp - ${ctf_name}-ctf:/root/
else
    echo -e "${RED}No rc directory found. Nothing to copy to container.${RESET}"
fi

# Create stop/rm script for container
cat << EOF > ${ctf_name}-stop.sh
#!/bin/bash
docker stop ${ctf_name}-ctf
docker rm ${ctf_name}-ctf
rm -f ${ctf_name}-stop.sh
EOF
chmod 755 ${ctf_name}-stop.sh

# Create a workdir for this CTF
docker exec ${ctf_name}-ctf mkdir /root/work

# Get a shell
echo -e "${GREEN}                         ______               ${RESET}"
echo -e "${GREEN}___________      ___________  /___________  __${RESET}"
echo -e "${GREEN}___  __ \\_ | /| / /_  __ \\_  __ \\  __ \\_  |/_/${RESET}"
echo -e "${GREEN}__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <  ${RESET}"
echo -e "${GREEN}_  .___/____/|__/ /_/ /_//_.___/\\____//_/|_|  ${RESET}"
echo -e "${GREEN}/_/                           by superkojiman  ${RESET}"
echo ""
docker exec -it ${ctf_name}-ctf /bin/bash
