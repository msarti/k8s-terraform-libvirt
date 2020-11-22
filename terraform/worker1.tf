
# creo l'immagine del worker1
resource "libvirt_volume" "kube-worker1-disk" {
 name = var.settings.worker1.primary_disk_name
 pool = libvirt_pool.cluster_pool.name
 source = var.settings.worker1.primary_disk_source
 format = var.settings.worker1.primary_disk_format
}

resource "libvirt_volume" "kube-worker1-disk2" {
  name           = var.settings.worker1.secondary_disk_name
  pool           = libvirt_pool.cluster_pool.name
  size           = var.settings.worker1.secondary_disk_size
  format         = var.settings.worker1.secondary_disk_format
}


resource "libvirt_domain" "kube-worker1" {
 
 # name should be unique!
   name = var.settings.worker1.name
   memory = var.settings.worker1.memory
   vcpu = var.settings.worker1.vcpu
 # add the cloud init disk to share user data
   cloudinit = libvirt_cloudinit_disk.commoninit.id
# set to default libvirt network
   network_interface {
      network_name = var.settings.network_name
      mac = var.settings.worker1.mac
      addresses  = [var.settings.worker1.ip_address]
 }
console {
   type = "pty"
   target_type = "serial"
   target_port = "0"
 }
disk {
   volume_id = libvirt_volume.kube-worker1-disk.id
 }
disk {
   volume_id = libvirt_volume.kube-worker1-disk2.id
 }

graphics {
   type = "spice"
   listen_type = "address"
   autoport = true
 }
}
