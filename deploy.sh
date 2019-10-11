#!/bin/bash

ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "cat \$HOME/deploy.sh"
ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "sudo sh \$HOME/deploy.sh"
# ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "sudo /home/ubuntu/deploy.sh"

exit 0