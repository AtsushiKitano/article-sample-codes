locals {
  config_file_path = "../config"

  config_files = {
    gce     = "gce.yaml"
    network = "networks.yaml"
  }

  gce_configs     = yamldecode(file(join("/", [local.config_file_path, local.config_files.gce])))
  network_configs = yamldecode(file(join("/", [local.config_file_path, local.config_files.network])))
  project         = var.project
}

variable "project" {}

module "network" {
  for_each = { for v in local.network_configs : v.name => v }
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/vpc_network"

  vpc_network = {
    name = each.value.name
  }

  subnetworks = each.value.subnetworks
  firewall    = each.value.firewall
  project     = local.project
}


module "gce" {
  for_each = { for v in local.gce_configs : v.instance.name => v }
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/compute/gce"

  enabled = each.value.enabled

  gce_instance = {
    name         = each.value.instance.name
    machine_type = each.value.instance.machine_type
    zone         = each.value.instance.zone
    subnetwork   = module.network[each.value.instance.subnetwork].subnetwork_self_link[each.value.instance.subnetwork]
    tags         = each.value.instance.tags
  }

  boot_disk = {
    name      = each.value.boot_disk.name
    size      = each.value.boot_disk.size
    interface = each.value.boot_disk.interface
    image     = each.value.boot_disk.image
  }
  project = local.project
}

resource "google_project_iam_member" "main" {
  project = local.project
  member  = "kitano.atsushi@cloud-ace.jp"
  role    = "roles/owner"
}
