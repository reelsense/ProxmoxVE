#!/usr/bin/env bash

# --- Color Definitions ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Script Logic ---
echo -e "${CYAN}--- ProxmoxVE Script Test Command Generator ---${NC}"
echo "This script will generate a command to run a helper script from your own GitHub fork and branch."
echo

# 1. Get User Input
read -p "Enter your GitHub username: " GITHUB_USER
if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}Error: GitHub username cannot be empty.${NC}"
    exit 1
fi

read -p "Enter your repository name [default: ProxmoxVE]: " GITHUB_REPO
# Use 'ProxmoxVE' as default if the user just presses Enter
GITHUB_REPO=${GITHUB_REPO:-ProxmoxVE}

read -p "Enter your branch name (e.g., step-ca-fixes) [default: dev]: " GITHUB_BRANCH
GITHUB_BRANCH=${GITHUB_BRANCH:-dev}

read -p "Enter the path to the script (e.g., ct/alpine-step-ca.sh): " SCRIPT_PATH
if [ -z "$SCRIPT_PATH" ]; then
    echo -e "${RED}Error: Script path cannot be empty.${NC}"
    exit 1
fi

# 2. Construct the URL and the final command
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"
FULL_URL="${BASE_URL}/${SCRIPT_PATH}"
FINAL_COMMAND="bash -c \"\$(curl -fsSL ${FULL_URL})\""

# 3. Display the result
echo
echo -e "${GREEN}Your test command is ready. Run this on your Proxmox VE host:${NC}"
echo "------------------------------------------------------------------"
echo -e "${YELLOW}${FINAL_COMMAND}${NC}"
echo "------------------------------------------------------------------"
echo

# 4. Ask if the user wants to execute it
read -p "Do you want to execute this command now? (Requires being on the Proxmox host) [y/N]: " EXECUTE_NOW
if [[ "$EXECUTE_NOW" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${CYAN}Executing command...${NC}"
    eval "$FINAL_COMMAND"
else
    echo "Exiting. Copy the command above to run it manually."
fi
