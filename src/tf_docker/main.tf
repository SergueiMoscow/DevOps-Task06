terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "ssh://ubuntu@51.250.91.130"
}

resource "random_password" "mysql_root_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_user_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql_image" {
  name = "mysql:8"
}

resource "docker_container" "mysql_container" {
  image = docker_image.mysql_image.name
  name  = "mysql_resource"
  ports {
    internal = 3306
    external = 3306
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_user_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}