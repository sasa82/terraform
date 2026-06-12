##!/bin/bash
## Prerequisite script - runs before ipsec configuration
## Installs strongSwan if not already installed

echo "Checking strongSwan installation..."
if ! command -v ipsec &> /dev/null; then
    echo "Installing strongSwan..."
    apt-get update -y
    apt-get install -y strongswan strongswan-pki
else
    echo "strongSwan already installed"
fi
