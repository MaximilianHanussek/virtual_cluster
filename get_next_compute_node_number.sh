#!/bin/bash

#This helper script will parse out the next compute node number in the row for node adding purposes


master_node_key_path=$(awk '/private_key_path/{getline; print}' terraform/vars.tf | awk -F ' = "' '{print $2}' | head -c -2) 	#Get path to SSH key of master node from tf variables file

search_line_number=$(grep -n "unicore-master" terraform/terraform.tfstate | cut -f1 -d:)					#Get line after that the master section starts
master_node_IP=$(tail -n +$search_line_number terraform/terraform.tfstate | grep "network.0.fixed_ip_v4" | awk -F ': "' '{print $2}' | head -c -3)	#Get public master node IP

highest_used_node_number=$(ssh -n -o StrictHostKeyChecking=no -i $master_node_key_path centos@$master_node_IP grep 'unicore-compute-node-' /etc/hosts | awk -F ' ' '{print $2}' | grep -Eo '[0-9]'+ | sort -rn | head -n 1)	#Get the current highest used node number from master host file

next_node_number=$(($highest_used_node_number + 1))	#Add 1 to current highest number to get the next number
echo -n $next_node_number > next_node_number		#Write number to file in order to make it available to terraform
