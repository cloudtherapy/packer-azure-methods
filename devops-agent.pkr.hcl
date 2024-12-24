packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

variable "subscription_id" {
  type = string
}

variable "resource_group" {
  type    = string
  default = "rg-shared-services"
}

variable "vnet_name" {
  type = string
  default = "vnet-shared-10-157-0"
}

variable "subnet_name" {
  type = string
  default = "snet-shared-10-157-0-0"
}

variable "compute_gallery_name" {
  type    = string
  default = "galcloudmethods"
}

variable "image_name" {
  type    = string
  default = "devops-agent"
}

source "azure-arm" "ubuntu" {
  subscription_id                     = var.subscription_id
  location                            = "East US"
  virtual_network_resource_group_name = var.resource_group
  virtual_network_name                = var.vnet_name
  virtual_network_subnet_name         = var.subnet_name
  managed_image_resource_group_name   = var.resource_group
  vm_size                             = "Standard_B2s"
  os_disk_size_gb                     = 30
  os_type                             = "Linux"
}

build {
  name = "ubuntu22"

  source "source.azure-arm.ubuntu" {
    name               = "ubuntu22"
    managed_image_name = "${var.image_name}"
    temp_compute_name  = "${var.image_name}"
    image_publisher    = "Canonical"
    image_offer        = "0001-com-ubuntu-server-jammyl"
    image_sku          = "22_04-lts"
    shared_image_gallery_destination {
      subscription         = var.subscription_id
      resource_group       = var.resource_group
      gallery_name         = var.compute_gallery_name
      image_name           = var.image_name
      image_version        = formatdate("YYYY.MMDD.hhmmss", timeadd(timestamp(), "-5h"))
      replication_regions  = ["East US"]
      storage_account_type = "Standard_LRS"
    }
    azure_tags = {
      "env:platform"      = var.label
      "image:create_date" = "{{ isotime \"2006-01-02 15:04:05\" }} UTC"
      "image:os"          = "Ubuntu LTS 22.04"
    }
  }

  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }

  provisioner "file" {
    destination = "/tmp/ansible-ubuntu-image.yml"
    source      = "ansible/devops.yml"
  }

  provisioner "shell" {
    script = "scripts/ubuntu-base-customize.sh"
  }
}