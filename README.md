# Virtual UNICORE cluster (VALET) on demand
Creating a virtual cluster on demand in an OpenStack environment including a UNICORE instance.

## Software Stack
The following software and tools are used to setup the virtual UNICORE cluster:

- Terraform (Infrastructure as a code)
- BeeGFS/BeeOND (Shared File System)
- TORQUE (Batch System)
- UNICORE Server (Middleware)
- UNICORE workflow system (Workflow System)

## Prerequisites
In order to setup VALET you need to fulfill the following prerequisites

- You need access to an OpenStack driven cloud (for example the [de.NBI cloud](https://cloud.denbi.de))
- Further you need access to the API and permissions to upload images
- An openrc file with the correct credentials needs to be available (can be donwloaded from the OpenStack Dashboard, Horizon)
- Installed version of [Terraform](https://www.terraform.io/) (tested with v0.11.13)
- Access to remote resources (internet)

## Installation and Usage
The following information will help you to setup and use the virtual UNICORE cluster

