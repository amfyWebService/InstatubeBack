#!/bin/bash

ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "sudo sh \$HOME/deploy.sh"

exit 0