#!/bin/bash
echo "=============================="; echo "Student Information"; echo "=============================="
echo "Name: Ali"; echo "Surname: Anatbek"; echo "Group: IT2-2309"; echo "Student ID: 41505"
echo "=============================="; echo "System Information"; echo "=============================="
echo "Username: $(whoami)"; echo "Hostname: $(hostname)"; echo "Current Date: $(date)"
echo "Operating System: $(uname -s -r)"; echo "Disk Usage:"; df -h / ; echo "Memory Usage:"; free -h
if [ -f ~/devops/anatbek_ali/Anatbek_Ali_info.txt ]; then
  echo "Student information file exists."
else
  echo "Student information file does not exist."
fi
