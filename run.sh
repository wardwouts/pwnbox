#!/usr/bin/env bash

set -u # Throw errors when unset variables are used
set -e # Exit on error

# Run wardwouts/pwnbox container in docker.
# Store your .gdbinit, .radare2rc, .vimrc, etc in a ./rc directory. The contents will be copied to
# /root/ in the container.

if [[ -z "${DOCKER_COMMAND}" ]]; then
    DOCKER_COMMAND=docker
fi

if [[ -z "${DOCKER_REPO_PREFIX}" ]]; then
    DOCKER_REPO_PREFIX=wardwouts
fi


ESC="\x1B["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

if [[ $# != 1 ]]; then
    ctf_name=${cdj##*\/}
else
    ctf_name="${1}"
fi

if [[ -z "$ctf_name" ]]; then
    echo -e "${RED}Missing argument CTF name.${RESET}"
    exit 0
fi

# Create docker container and run in the background
# Add this if you need to modify anything in /proc: --privileged

# Originally in following command:
# --security-opt seccomp:unconfined \
# not a good idea. I think the SYS_PTRACE capability will suffice for now
# see also http://man7.org/linux/man-pages/man7/capabilities.7.html
$DOCKER_COMMAND run -it \
    -h ${ctf_name} \
    --cap-add=SYS_PTRACE \
    -d \
    --name ${ctf_name} \
    ${DOCKER_REPO_PREFIX}/pwnbox

# Copy files in rc to container
if [[ -d rc ]]; then
    if [[ $(find rc | wc -l) -gt 1 ]]; then
        $DOCKER_COMMAND cp rc/. ${ctf_name}:/root/
    fi
else
    echo -e "${RED}No rc directory found. Nothing to copy to container.${RESET}"
fi

# Create a workdir for this CTF
$DOCKER_COMMAND exec ${ctf_name} mkdir /root/work

# Get a shell
echo -e "${GREEN}                         ______               ${RESET}"
echo -e "${GREEN}___________      ___________  /___________  __${RESET}"
echo -e "${GREEN}___  __ \\_ | /| / /_  __ \\_  __ \\  __ \\_  |/_/${RESET}"
echo -e "${GREEN}__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <  ${RESET}"
echo -e "${GREEN}_  .___/____/|__/ /_/ /_//_.___/\\____//_/|_|  ${RESET}"
echo -e "${GREEN}/_/                           by superkojiman  ${RESET}"
echo ""
echo -e "${GREEN}to detach container without stopping it type: ${RESET}"
echo -e "${GREEN}CTRL-p CTRL-q                                 ${RESET}"
$DOCKER_COMMAND attach ${ctf_name}
