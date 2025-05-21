#!/bin/bash

# Color Palette based on character theme
WHITE="\033[1;37m"
BLUE_LIGHT="\033[38;5;117m"
BLUE_DARK="\033[38;5;25m"
GOLD="\033[38;5;220m"
GRAY="\033[38;5;245m"
RESET="\033[0m"

echo_blank() { echo "‎ "; }

print_info() {
  echo_blank
  echo -e " ${WHITE}-> ${1}${RESET}"
  echo_blank
}

print_warn() {
  echo_blank
  echo -e " ${WHITE}-> ${GOLD}WARNING:${RESET} $1"
  echo_blank
}

abort_with_error() {
  echo_blank
  echo -e " ${WHITE}-> \033[31mERROR:${RESET} $1"
  echo_blank
  exit 1
}

check_node() {
  if ! command -v node &> /dev/null; then
    abort_with_error "Node.js is not installed. Please install it first."
  fi

  if ! command -v npm &> /dev/null && command -v corepack &> /dev/null; then
    print_info "${GOLD}npm not found. Trying to enable with corepack...${RESET}"
    corepack enable npm || abort_with_error "Failed to enable npm with corepack."
  fi
}

use_nvm() {
  if [ -f .nvmrc ]; then
    print_info "${BLUE_LIGHT}.nvmrc found. Switching Node.js version with nvm...${RESET}"
    nvm use || print_warn "Failed to switch Node version. Continuing anyway."
  fi
}

install_dependencies() {
  if [ ! -f package.json ]; then
    abort_with_error "package.json not found. Are you in the correct project directory?"
  fi

  if [ ! -d node_modules ]; then
    print_info "${GOLD}Installing dependencies (node_modules not found)...${RESET}"

    if [ -f package-lock.json ]; then
      npm ci --prefer-offline --no-audit --progress=false
    else
      npm install --prefer-offline --no-audit --progress=false
    fi

    print_info "${BLUE_LIGHT}Dependencies installed successfully.${RESET}"
  else
    print_info "${BLUE_DARK}node_modules already exists. Skipping install.${RESET}"
  fi
}

start_app() {
  print_info "${BLUE_LIGHT}Starting application...${RESET}"
  exec ${RUN_COMMAND:-npm start}
}

# Main Execution Flow
check_node
use_nvm
install_dependencies
start_app
