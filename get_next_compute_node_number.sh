#!/bin/bash

master_node_key_path=$(awk '/private_key_path/{getline; print}' terraform/vars.tf | awk -F ' = "' '{print $2}' | head -c -2)

search_line_number=$(grep -n "unicore-master" terraform/terraform.tfstate | cut -f1 -d:)
master_node_IP=$(tail -n +$search_line_number terraform/terraform.tfstate | grep "network.0.fixed_ip_v4" | awk -F ': "' '{print $2}' | head -c -3)

highest_used_node_number=$(ssh -n -o StrictHostKeyChecking=no -i $master_node_key_path centos@$master_node_IP grep 'unicore-compute-node-' /etc/hosts | awk -F ' ' '{print $2}' | grep -Eo '[0-9]'+ | sort -rn | head -n 1)

next_node_number=$(($highest_used_node_number + 1))
echo -n $next_node_number > next_node_number
