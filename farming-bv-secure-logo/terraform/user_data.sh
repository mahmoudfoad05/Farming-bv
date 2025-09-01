#!/bin/bash
set -euxo pipefail
dnf update -y
# Ensure Python for Ansible and basic tools
dnf install -y python3 unzip git
# Create a marker
echo "Provisioned $(date)" > /etc/provisioned.txt
# Open ports handled by SG. Nothing else here.
