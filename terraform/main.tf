# add the provider
terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.2"
    }
  }
}

variable "settings" {
  default = {
    pool = "cluster"
    network_name = "k8snet"
    network_addesses = ["10.17.3.0/24", "2001:db8:ca2:2::1/64"]
    master = {
      name = "kube-master"
      primary_disk_name = "kube-master-01.qcow2"
      primary_disk_source = "/mnt/disco2/vms/focal-server-cloudimg-amd64.img"
      primary_disk_format = "qcow2"
      memory = "2048"
      vcpu = 2
      mac = "52:54:00:02:40:8b"
      ip_address = "10.17.3.3"
    }
    worker1 = {
      name = "kube-worker1"
      primary_disk_name = "kube-worker1-01.qcow2"
      primary_disk_source = "/mnt/disco2/vms/focal-server-cloudimg-amd64.img"
      primary_disk_format = "qcow2"
      secondary_disk_name = "kube-worker1-02.qcow2"
      secondary_disk_format = "qcow2"
      secondary_disk_size = 1024*1024*1024
      memory = "2048"
      vcpu = 2
      mac = "6c:6f:06:9b:82:df"
      ip_address = "10.17.3.4"
    }
    worker2 = {
      name = "kube-worker2"
      primary_disk_name = "kube-worker2-01.qcow2"
      primary_disk_source = "/mnt/disco2/vms/focal-server-cloudimg-amd64.img"
      primary_disk_format = "qcow2"
      secondary_disk_name = "kube-worker2-02.qcow2"
      secondary_disk_format = "qcow2"
      secondary_disk_size = 1024*1024*1024
      memory = "2048"
      vcpu = 2
      mac = "6c:6f:06:9b:82:dc"
      ip_address = "10.17.3.5"
    }
    worker3 = {
      name = "kube-worker3"
      primary_disk_name = "kube-worker3-01.qcow2"
      primary_disk_source = "/mnt/disco2/vms/focal-server-cloudimg-amd64.img"
      primary_disk_format = "qcow2"
      secondary_disk_name = "kube-worker3-02.qcow2"
      secondary_disk_format = "qcow2"
      secondary_disk_size = 1024*1024*1024
      memory = "2048"
      vcpu = 2
      mac = "6c:6f:06:9b:82:dd"
      ip_address = "10.17.3.6"
    }
  }
}

resource "libvirt_pool" "cluster_pool" {
  name = var.settings.pool
  type = "dir"
  path = "/mnt/disco2/cluster_pool"
}

resource "libvirt_network" "k8s_network" {
  name = var.settings.network_name
  mode = "nat"
  domain = "k8s.local"
  addresses = var.settings.network_addesses
  dns {
    enabled = true
    local_only = true
  }

}


provider "libvirt" {
 uri = "qemu:///system"
}

variable "diskBytes" { default = 1024*1024*1024 }

# aggiungo il cloudinit disk al pool
resource "libvirt_cloudinit_disk" "commoninit" {
 name = "commoninit.iso"
 pool = libvirt_pool.cluster_pool.name
 user_data = data.template_file.user_data.rendered
}
# configurazione cloudinit
data "template_file" "user_data" {
 template = file("${path.module}/cloud_init.cfg")
}
