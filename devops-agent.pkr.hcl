packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

source "azure-arm" "devops_agent" {

  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "East US"
  managed_image_name                = "devops-agent"
  managed_image_resource_group_name = "rg-shared-services"
  os_type                           = "Linux"
  subscription_id                   = "eef2d7b1-c33f-48ec-a949-5b87caad5c13"
  use_interactive_auth              = true
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.devops_agent"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}