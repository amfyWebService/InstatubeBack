#!/bin/bash

ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "sudo ./deploy.sh"

exit 0