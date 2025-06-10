#!/bin/bash

# Default playbook name
PLAYBOOK="generate_clients.yml"

# Help message
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -n NUM     Number of clients to generate (required)"
  echo "  -h         Show this help message and exit"
  echo ""
  echo "Example:"
  echo "  $0 -n 10"
  exit 1
}

# Parse command-line arguments
while getopts ":n:h" opt; do
  case $opt in
    n)
      NUM_CLIENTS=$OPTARG
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
  esac
done

# Check if number of clients was provided
if [[ -z "$NUM_CLIENTS" ]]; then
  echo "Error: You must specify the number of clients using -n"
  usage
fi

# Run playbook in a loop
for ((i = 1; i <= NUM_CLIENTS; i++)); do
  echo "Generating client $i of $NUM_CLIENTS..."
  ansible-playbook "$PLAYBOOK" -vv

  if [ $? -ne 0 ]; then
    echo "❌ Ansible playbook failed on iteration $i. Exiting."
    exit 1
  fi
done

echo "✅ All $NUM_CLIENTS clients generated successfully."

