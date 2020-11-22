Deploy a Kubernetes cluster from scratch with libvirt, Terraform and Ansible.

## Requirements
* QEMU / KVM virtualization environment and [libvirt](https://libvirt.org/) installed. virt-manager is recommended for better control
* Terraform and [libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt) installed (Read carefully the [terraform v13 migration notes](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/docs/migration-13.md))
* Ansible installed

## Terraform Configuration
The current configuration has one master node and three worker nodes. Currently it is not possible to configure multiple master nodes while you can configure as many worker nodes as you want.

First of all download the Ubuntu server cloud image and save it to a file system location. [Ubuntu 20.04 image](https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img) is recommended.

Plan your infrastructure. Decide how many worker nodes, memory, vcpu to assign and modify the settings variables memory and vcpu in main.tf accordingly.

The script creates a network for the cluster and a pool for the storage, check the CIDR of the network and set the path for the pool. Set the IP addresses of the nodes according to the created network. Also remember to set a random and unique mac address for each node.

A second disk is created for each worker node to be used for installing a storage manager, such as OpenEBS or Rook / Ceph. The secondary_disk_size variable sets the size (in bytes).

Finally, the cloud_init.cfg file must be created. You can start from a copy of the cloud_init.cfg.sample file and adapt it to your needs. For the script to work properly you need to copy the ssh public key to the ssh_authorized_keys and you can set a password for the ansible user so that you can log into the console. If you want you can create other users as you wish.

## Ansible configuration

Ansible's configuration basically consists in setting up the inventory consistently with what is set in Terraform.

Set up the hosts file with the list of nodes by assigning the appropriate groups. Remember that you can currently only have one master node.

Under the host_vars folder you need to put a file for each of the hosts configured in the hosts file. The file name must be identical to the host name and must contain host specific variables as per the example. It is essential to set the ansible_host variable with the ip address previously set in Terraform.

Check the crio_version and kubernetes_version variables in the group_vars/all file. By changing these variables you can set the versions of cri-o and Kubernetes.

## Create your infrastucture
You are now ready to build your infrastructure. To do this, type make set-up and wait for the build to run. At the end you will be able to connect to the master node, via user ansible or whoever you have configured, and verify the installation.

## Destroy your infrascructure
As simple as it is to create the infrastructure, it is equally simple to destroy it. Type make tear-down from the project root and wait for the script to run.
Terraform destroys all the resources it has created: pools, disks, networks and domains. At this point you are ready to start from scratch.

Pay attention that the command does not ask for any confirmation. It is implied that you know what you are doing.

