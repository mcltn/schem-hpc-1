variable softlayer_username {}
variable softlayer_api_key {}
variable base_template_image {}
variable compute_template_image {}
variable datacenter {}
variable domain {}
variable domain_username {}
variable domain_password {}
variable dc_hostname {}
variable hn_hostname {}
variable cn_hostname {}
variable compute_node_count {}

provider "ibmcloud" {
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

data "ibmcloud_infra_image_template" "base_template" {
  name = "${var.base_template_image}"
}
data "ibmcloud_infra_image_template" "compute_template" {
  name = "${var.compute_template_image}"
}

resource "ibmcloud_infra_virtual_guest" "domaincontroller" {
  count = "1"
  hostname = "${var.dc_hostname}"
  domain = "${var.domain}"
  image_id = "${data.ibmcloud_infra_image_template.base_template.id}"
  datacenter = "${var.datacenter}"
  cores = 4
  memory = 4096
  network_speed = 1000
  local_disk = false
  private_network_only = true,
  hourly_billing = true,
  tags = ["schematics","domaincontroller"]
  user_metadata = "#ps1_sysnative\nscript: |\n<powershell>\n\n</powershell>"
}
