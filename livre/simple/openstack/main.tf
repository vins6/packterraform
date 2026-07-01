# Define required providers
terraform {
required_version = ">=1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  cloud = "devstack-admin"
}

  data "openstack_images_image_v2" "cirros" {
  name        = "cirros-0.6.3-aarch64-disk"
  most_recent = true
}
# Create a web server
resource "openstack_compute_instance_v2" "exemple" {

  name = "terraform-example"
  image_name ="data.openstack_images_image_v2.cirros.id"
  flavor_name ="m1.nano"

  user_data_replace_on_change= <<- EOF
    #!/bin/bash
    echo "Hello World" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF

}
