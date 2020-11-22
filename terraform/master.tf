# libvirt.tf

# creo l'immagine del master
resource "libvirt_volume" "kube-master-disk" {
 name = var.settings.master.primary_disk_name
 pool = libvirt_pool.cluster_pool.name
 source = var.settings.master.primary_disk_source
 format = var.settings.master.primary_disk_format
}

# Define KVM domain to create
resource "libvirt_domain" "kube-master" {
 
 # name should be unique!
   name = var.settings.master.name
   memory = var.settings.master.memory
   vcpu = var.settings.master.vcpu
 # add the cloud init disk to share user data
   cloudinit = libvirt_cloudinit_disk.commoninit.id
# set to default libvirt network
   network_interface {
      network_name = var.settings.network_name
      mac = var.settings.master.mac
      addresses  = [var.settings.master.ip_address]
 }
console {
   type = "pty"
   target_type = "serial"
   target_port = "0"
 }
disk {
   volume_id = libvirt_volume.kube-master-disk.id
 }
graphics {
   type = "spice"
   listen_type = "address"
   autoport = true
 }
}

