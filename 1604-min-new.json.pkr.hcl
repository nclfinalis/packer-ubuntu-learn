packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "build_cpu_cores" {
  type    = string
  default = "2"
}

variable "build_memory" {
  type    = string
  default = "1024"
}

variable "build_name" {
  type    = string
  default = "ubuntu-1604"
}

variable "cpu_cores" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "737ae7041212c628de5751d15c3016058b0e833fdc32e7420209b76ca3d0a535"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type    = string
  default = "http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "name" {
  type    = string
  default = "cbednarski/ubuntu-1604"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

# could not parse template for following block: "template: hcl2_upgrade:2: bad character U+0060 '`'"

source "virtualbox-iso" "{{_user_`build_name`_}}-vbox" {
  boot_command            = ["<enter><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", "hostname={{ user `build_name` }}-vmware ", "fb=false debconf/fronten=d=noninteractive ", "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false ", "initrd=/install/initrd.gz -- <enter>"]
  boot_wait               = "5s"
  disk_size               = "{{user `disk_size`}}"
  guest_additions_path    = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = "{{user `headless`}}"
  http_directory          = "http"
  iso_checksum            = "{{user `iso_checksum_type`}}:{{user `iso_checksum`}}"
  iso_url                 = "{{user `iso_url`}}"
  shutdown_command        = "echo 'vagrant' | sudo -S poweroff"
  ssh_password            = "{{user `ssh_username`}}"
  ssh_timeout             = "20m"
  ssh_username            = "{{user `ssh_password`}}"
  vboxmanage              = [["modifyvm", "{{.Name}}", "--memory", "{{user `build_memory`}}"], ["modifyvm", "{{.Name}}", "--cpus", "{{user `build_cpu_cores`}}"]]
  vboxmanage_post         = [["modifyvm", "{{.Name}}", "--memory", "{{user `memory`}}"], ["modifyvm", "{{.Name}}", "--cpus", "{{user `cpu_cores`}}"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "{{ user `build_name` }}-vbox"
}

# could not parse template for following block: "template: hcl2_upgrade:2: bad character U+0060 '`'"

source "vmware-iso" "{{_user_`build_name`_}}-vmware" {
  boot_command        = ["<enter><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "noapic preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", "hostname={{ user `build_name` }}-vmware ", "fb=false debconf/frontend=noninteractive ", "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false ", "initrd=/install/initrd.gz -- <enter>"]
  boot_wait           = "5s"
  disk_size           = "{{user `disk_size`}}"
  headless            = "{{user `headless`}}"
  http_directory      = "http"
  iso_checksum        = "{{user `iso_checksum_type`}}:{{user `iso_checksum`}}"
  iso_url             = "{{user `iso_url`}}"
  shutdown_command    = "echo 'vagrant' | sudo -S poweroff"
  ssh_password        = "{{user `ssh_username`}}"
  ssh_timeout         = "20m"
  ssh_username        = "{{user `ssh_password`}}"
  tools_upload_flavor = "linux"
  vm_name             = "{{ user `build_name` }}-vmware"
  vmx_data = {
    "cpuid.coresPerSocket"                  = "1"
    "ethernet0.addresstype"                 = "generated"
    "ethernet0.bsdname"                     = "en0"
    "ethernet0.connectiontype"              = "nat"
    "ethernet0.displayname"                 = "Ethernet"
    "ethernet0.linkstatepropagation.enable" = "FALSE"
    "ethernet0.pcislotnumber"               = "32"
    "ethernet0.present"                     = "TRUE"
    "ethernet0.virtualdev"                  = "e1000"
    "ethernet0.wakeonpcktrcv"               = "FALSE"
    memsize                                 = "{{user `build_memory`}}"
    numvcpus                                = "{{user `build_cpu_cores`}}"
  }
  vmx_data_post = {
    "cpuid.coresPerSocket" = "1"
    memsize                = "{{user `memory`}}"
    numvcpus               = "{{user `cpu_cores`}}"
  }
}

build {
  sources = ["source.virtualbox-iso.{{_user_`build_name`_}}-vbox", "source.vmware-iso.{{_user_`build_name`_}}-vmware"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts-1604/packages.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts-1604/vagrant.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["${var.build_name}-vbox"]
    script          = "scripts-1604/virtualbox.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["${var.build_name}-vbox"]
    script          = "scripts-1604/virtualbox_cleanup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["${var.build_name}-vmware"]
    script          = "scripts-1604/vmware.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["${var.build_name}-vmware"]
    script          = "scripts-1604/vmware_cleanup.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "{{ .BuildName }}.box"
  }
}
