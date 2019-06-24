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
Change into the terraform directory if not already done and open the `vars.tf` file. You will find a bunch of defined variables
but the only ones you need touch are the following. A comprehensive list can be found in the table below:

* Change the names of the flavors for the master node and compute node entry to fitting ones. Do not underestimate the neccessary resources for the master node. Suggestion would be 8GB RAM and 8-16 CPU cores.
For the compute nodes you can choose what you find appropriate for your purposes.



| Variable               | Default value                 | Unit             | Change               |
| ---------------------- |:-----------------------------:|:----------------:|:--------------------:|
| beeond_disc_size       | 10                            | Gigabytes        | yes (not required)   |
| beeond_storage_backend | quobyte_hdd                   |     -            | yes (poss. required) |
| flavors                | de.NBI small disc             | 8 CPUs, 16GB RAM | yes (poss. required) |
| compute_node_count     | 2                             | Instances        | yes (not required)   |
| image_master           | unicore_master_centos         |     -            | no                   |
| image_compute          | unicore_compute_centos        |     -            | no                   |
| openstack_key_name     | test                          |     -            | yes (required)       |
| private_key_path       | /path/to/private/key          |     -            | yes (required)       |
| name_prefix            | unicore-                      |     -            | no                   |
| security_groups        | virtual-unicore-cluster-public|     -            | no                   |
| network                | denbi_uni_tuebingen_external  |     -            | yes (poss. required) |










