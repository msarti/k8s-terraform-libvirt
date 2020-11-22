
# creo l'immagine del worker1
resource "libvirt_volume" "kube-worker2-disk" {
 name = var.settings.worker2.primary_disk_name
 pool = libvirt_pool.cluster_pool.name
 source = var.settings.worker2.primary_disk_source
 format = var.settings.worker2.primary_disk_format
}
resource "libvirt_volume" "kube-worker2-disk2" {
  name           = var.settings.worker2.secondary_disk_name
  pool           = libvirt_pool.cluster_pool.name
  size           = var.settings.worker2.secondary_disk_size
  format         = var.settings.worker2.secondary_disk_format
}


resource "libvirt_domain" "kube-worker2" {
 
   name = var.settings.worker2.name
   memory = var.settings.worker2.memory
   vcpu = var.settings.worker2.vcpu
   cloudinit = libvirt_cloudinit_disk.commoninit.id
   network_interface {
      network_name = var.settings.network_name
      mac = var.settings.worker2.mac
      addresses  = [var.settings.worker2.ip_address]

 }
console {
   type = "pty"
   target_type = "serial"
   target_port = "0"
 }
disk {
   volume_id = libvirt_volume.kube-worker2-disk.id
 }
disk {
   volume_id = libvirt_volume.kube-worker2-disk2.id
 }

graphics {
   type = "spice"
   listen_type = "address"
   autoport = true
 }
}
