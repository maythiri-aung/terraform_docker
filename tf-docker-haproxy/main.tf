resource "docker_network" "haproxy_network" {
  name   = "haproxy-network"
  driver = "bridge"
  ipam_config {
    subnet = "172.19.0.0/16"
    gateway = "172.19.0.1"
  }
}

resource "docker_container" "web1" {
  name  = "web1"
  image = "hashicorp/http-echo"
  ports {
    internal = 8080
    external = 8081
  }
  networks_advanced {
    name = docker_network.haproxy_network.name
    ipv4_address  = "172.19.0.2"
  }
  command = ["-listen=:8080", "-text=May Web Server 1"]
}

resource "docker_container" "web2" {
  name  = "web2"
  image = "hashicorp/http-echo"
  ports {
    internal = 8080
    external = 8082
  }
  networks_advanced {
    name = docker_network.haproxy_network.name
    ipv4_address  = "172.19.0.3"
  }
  command = ["-listen=:8080", "-text=May Web Server 2"]
}

resource "docker_container" "web3" {
  name  = "web3"
  image = "hashicorp/http-echo"
  ports {
    internal = 8080
    external = 8083
  }
  networks_advanced {
    name = docker_network.haproxy_network.name
    ipv4_address  = "172.19.0.4"
  }
  command = ["-listen=:8080", "-text=May Web Server 3"]
}

resource "docker_container" "haproxy" {
  name  = "haproxy"
  image = "haproxytech/haproxy-alpine:2.4"
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 8404
  }
  volumes {
    container_path = "/usr/local/etc/haproxy"
    host_path      = "/home/vagrant/terraform-cop/tf-docker-haproxy/haproxy"
    read_only      = true
  }
  volumes {
    container_path = "/etc/ssl/private"
    host_path      = "/home/vagrant/terraform-cop/tf-docker-haproxy/certs"
    read_only      = true
  }
  networks_advanced {
    name = docker_network.haproxy_network.name
    ipv4_address  = "172.19.0.5"
  }
}

