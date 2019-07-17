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

## Latest Images
This section will list the most up to date and tested images for the master and compute nodes. If you want to use older images for some reasons you will need to change the names in the Terraform`vars.tf` file. 

#### Current
- master image  : unicore_master_centos_20190712.qcow2
- compute image : unicore_compute_centos_20190711.qcow2

#### Old
- master image  : -
- compute image : -


## Installation and Usage
The following information will help you to setup and use the virtual UNICORE cluster. This guide is tested for Linux on CentOS7 with Terraform version 0.11.13. 

### 1. Download/clone the git repository
In order to use the sources you need to download or clone this git repository to your local machine.
<pre>git clone https://github.com/MaximilianHanussek/virtual_cluster.git</pre>

You can also download it as a ZIP archive from the website of the repository or via `wget`
<pre>wget https://github.com/MaximilianHanussek/virtual_cluster/archive/master.zip</pre>
you will find it as `master.zip`.

### 2. Source openstack credentials and initialize
Before we modify the required variables of Terraform for your OpenStack environment you will need 
to source your openstack credentials as environment variables and initialize Terraform.
You can simply source your openstack credentials by downloading a so-called openrc file from the OpenStack dashboard also known as Horizon, to your local machine. After you have done that source it with the following command
<pre>source /path/to/rc/file</pre>

Normally you should be asked for your password. Enter it and comfirm with enter. You will get no response, but you can check if everything worked well if you have the openstack client installed by running the following command
<pre>openstack image list</pre>
After that you should see a list of images that are available in your project.

Further we need to initialize Terraform. Therefore change into the `terraform` directory of the downloaded git repo and run
<pre>terraform init</pre>

If everything worked out you should see the following output:
<pre>Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.local: version = "~> 1.3"
* provider.openstack: version = "~> 1.19"
* provider.tls: version = "~> 2.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
</pre>

### 3. Configure terraform variables
In order to start the virtual cluster you will need a few variables we can not set for you.
Change into the terraform directory if not already done and open the `vars.tf` file. You will find a bunch of defined variables, a comprehensive list can be found in the table below. The ones you will need to touch for sure are marked with `yes (required)`. The ones you can change but do not have to change are marked with `yes (not required)`. The ones marked with `yes (poss. required)` need to be changed if you are running VALET on a non de.NBI cloud site or even not on the de.NBI cloud site Tübingen. As these values and namnes only exists in these cloud environments. Variables you are not allowed to change are marked with `no`. If you change one of the `no` tagged variables it could or will break the configuration process.

#### Variable explanantion
* beeond_disc_size: Sets the cinder volume size of the volumes attached to the master node and the two compute nodes. The shared file system will have the set size in gigabytes times three, for every participating node. So for 10GB it will 30GB. Set the size according to your needs and available resources.
* beeond_storage_backend: Sets the name of the storage backend for the cinder volumes, choose the appropriate of your cloud site.
* flavors: Sets the used compute resources (CPUs, RAM, ...) Recommended for the master node are 8 CPUs and at least 16GB RAM.
* compute_node_count: Sets the number of compute nodes (current configuration works only with two). 
* image_master (name): Sets the image name to be used for the master node. Will be downloaded automatically. 
* image_compute (name): Sets the image name to be used for the master node. Will be downloaded automatically.
* image_master (image_source_url): Download URL to the master node image, please set to name of current master image you will find above.
* image_compute (image_source_url): Download URL to the compute node image, please set to name of current compute image you will find above.
* openstack_key_name: Sets the SSH key name of your OpenStack environment (Keypair is required to be set up already). 
* private_key_path: Sets the path to your private key in order to access the VMs and run configuration scripts.
* name_prefix: Sets a prefix for the names of the starting VMs
* security_groups: Sets the names and the security groups itself (do not need be to exist)
* network: Sets the network to be used

| Variable                           | Default value                   | Unit             | Change               |
| ---------------------------------- |:-------------------------------:|:----------------:| -------------------- |
| beeond_disc_size                   | 10                              | Gigabytes        | yes (not required)   |
| beeond_storage_backend             | quobyte_hdd                     |     -            | yes (poss. required) |
| flavors                            | de.NBI small disc               | 8 CPUs, 16GB RAM | yes (poss. required) |
| compute_node_count                 | 2                               | Instances        | no                   |
| image_master (name)                | unicore_master_centos_IMAGEDATE |     -            | yes (not required)   |
| image_compute (name)               | unicore_compute_centos_IMAGEDATE|     -            | yes (not required)   |
| image_master (image_source_url)    | unicore_master_centos_IMAGEDATE |     -            | yes (not required)   |
| image_compute (image_source_url)   | unicore_compute_centos_IMAGEDATE|     -            | yes (not required)   |
| openstack_key_name                 | test                            |     -            | yes (required)       |
| private_key_path                   | /path/to/private/key            |     -            | yes (required)       |
| name_prefix                        | unicore-                        |     -            | no                   |
| security_groups                    | virtual-unicore-cluster-public  |     -            | no                   |
| network                            | denbi_uni_tuebingen_external    |     -            | yes (poss. required) |

### 4. Start Terraform setup
After the Terraform variables are setup correctly we can go on to start the configuration process.
In order to do this, change into the `terraform` directory of the Git repository and first run a dry run with
<pre>terraform plan</pre>

Terraform will now inform you what it will do and checks if the syntax of the terraform files (.tf)a re all correct.
If an error occur please follow the notes from Terraform and asure that you have sourced your openrc credentials file and initialized the Terraform plugins with `terraform init`.

If everything looks reasonable we can start with the real action executing
<pre>terraform apply</pre>

This command will first set up the required volumes, then the security group. Afterwards the required images will be downloaded and imported into the OpenStack environment, which can take some time dependent on the network connection (compute image: 1.93GB, master image: 4.40GB). The next step will fire up the VMs and also attaches the cinder volumes. A subsequent script will mount the volumes, create one time SSH keys and distribute them on the different VMs so they can talk with each other without using your general private key for obvious security reasons. In the end the shared file system based on BeeOND will be started, the TORQUE cluster is started and in the end the UNICORE components. All this will take around 5-10 mins.
In the end you will have a fully setup UNICORE cluster that you can access like explained in Chapter 5.
But of course you can use just the usual TORQUE batch system without UNICORE and submitting jobs to a queue. 

### 5. Access your UNICORE cluster
There are different ways to access the UNICORE cluster. One possibility is to use UNICORE Commandline Client (UCC) which can be downloaded [here](https://sourceforge.net/projects/unicore/files/Clients/Commandline%20Client/7.13.0/). The second possibility is to use the UNICORE Rich Client (URC), you can donwload [here](https://sourceforge.net/projects/unicore/files/Clients/GUI%20Client/7.4.1/). In this instructions we will focus on the second possibility as this is the more convenient one.

In order to use the URC follow the steps below:
1. Download the URC to your local computer (the same you have started)
2. Unpack it and start the Application
3. It will ask your for the credentials, we will use the demo credentials as this is also the user who 
is already in the UNICORE user database. Please also check to save the password (which is 321 if yopu should forget it).
4. Afterwards go to the Workbench and add the new Registry by right-clicking into the window titled with `Grid Browser` and choose `Add Registry`. You can freely choose a name and afterwards replace `localhost` with the IP of your master node. You can find this information in the OpenStack dashboard (Horizon) or in Terraform. The rest of the URL needs to stay the same.
Here an Example:
<pre>https://42.42.42.42:8080/REGISTRY/services/Registry?res=default_registry</pre>

Now you can start a small test run by submitting a script to the UNICORE cluster for example via the also configured Workflow System. For this purpose create a new workflow project and add a script (v2.2) to the worklfow, connect it with the green play button and enter for example in the script
<pre>
whoami
uname -r
date</pre>

Click on the play button chose the available worjkflow engine and click on finish. You will see the worklfow running in the Grid Browser window if you unfold the name of Registry you have chosen, the `Workflow engine` and the `Workflows` icon. The output is accessible in the folder `working directory of ...`.

For further complex workflows and further explanations on UNICORE we refer to the official documentation which you can find [here](https://www.unicore.eu/documentation/).


### 6. Start and add new node to existing cluster
It might happen that the initial cluster resources are not sufficient for the applied workload and more nodes could solve the problem. For this case we provide a mechanism that will automatically start a new node (via terraform). Add the new 
node to the already existing BeeOND file system and also make it available as a resource for the  batch system (TORQUE).
As last task UNICORE will be made aware of the new available resources. 
In order to add a new node you only have to go in the root repository directory where you find the script `start_up_new_node`. This wrapper script takes care of all the tasks explained shortly above. The only thing you need to do is to enter the path to your openstack `rc file` and enter the corresponidng password if you are asked for it.
<pre>sh start_up_new_node /path/to/rc/file</pre>

After some minutes you will have a new node added to your existng cluster.


### 7. Remove a node from the cluster
For the case you want to free some resources and want to downgarde your current cluster we also provide a removing procedure.
Please change into the root directory of the repository and run the following script:
<pre>sh stop_node</pre>

The lastly added node will be chosen to be removed from the cluster. First no new jobs are allowed to be scheduled onn the node for removal. After all currently running jobs on this node are finished the node is removed from TORQUE. In the next step the node is removed from the BeeOND shared file system. First no new data has to be written to the volume of this node. Then all the data distributed on this node is migarted to the other nodes (if possible, means enough capacity is left). At the end the node is deleted from the host file on the master node and therefore completely decoupled. As a final step the the resources available to UNICORE are updated. In the future we also plan to completely destroy the VM and free the resources.
