#!/bin/bash

ssh -i ./clemongo ubuntu@$SERVER_IP_ADDRESS "sudo \$HOME/deploy.sh"