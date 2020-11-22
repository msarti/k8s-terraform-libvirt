
# creo l'immagine del worker1
resource "libvirt_volume" "kube-worker3-disk" {
 name = var.settings.worker3.primary_disk_name
 pool = libvirt_pool.cluster_pool.name
 source = var.settings.worker3.primary_disk_source
 format = var.settings.worker3.primary_disk_format
}

resource "libvirt_volume" "kube-worker3-disk2" {
  name           = var.settings.worker3.secondary_disk_name
  pool           = libvirt_pool.cluster_pool.name
  size           = var.settings.worker3.secondary_disk_size
  format         = var.settings.worker3.secondary_disk_format
}


resource "libvirt_domain" "kube-worker3" {
 
   name = var.settings.worker3.name
   memory = var.settings.worker3.memory
   vcpu = var.settings.worker3.vcpu
   cloudinit = libvirt_cloudinit_disk.commoninit.id
   network_interface {
      network_name = var.settings.network_name
      mac = var.settings.worker3.mac
      addresses  = [var.settings.worker3.ip_address]
 }
console {
   type = "pty"
   target_type = "serial"
   target_port = "0"
 }
disk {
   volume_id = libvirt_volume.kube-worker3-disk.id
 }
disk {
   volume_id = libvirt_volume.kube-worker3-disk2.id
 }

graphics {
   type = "spice"
   listen_type = "address"
   autoport = true
 }
}
