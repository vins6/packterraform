terraform {
    required_version = ">= 1.6.0"
  required_providers {
    openstack = {
      source  = "hashicorp/openstack"
      version = "~> 3.0"
    }
  }
}
provider "openstack" {
    cloud = "devstack-admin"
}
#Reseau
resource "openstack_networking_network_v2" "networktest"{
  name = "testopenstack"
  admin_state_up = true
  

}
#Sous réseau "public"
resource "openstack_networking_subnet_v2" "public_subnet1" {
  name = "public-subnet"
  network_id = openstack_networking_network_v2.networktest.id
  cidr = "10.0.0.0/24"
  ip_version = 4
  
}
#Sous réseau privé
resource "openstack_networking_subnet_v2" "private_subnet"{
  name = "private-subnet"
  network_id = openstack_network.networktest.id
  cidr = "10.0.1.0/24"
  ip_version = 4
  
}

# Réseau externe de DevStack (récupéré, pas créé)
data "openstack_networking_network_v2" "external" {
  name = "public"
}

# Routeur relié au réseau externe = la passerelle vers l'extérieur
resource "openstack_networking_router_v2" "router" {
  name                = "test-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

# On rattache le sous-réseau public au routeur (équivalent de l'association route table)
resource "openstack_networking_router_interface_v2" "public_iface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.public_subnet.id
}
