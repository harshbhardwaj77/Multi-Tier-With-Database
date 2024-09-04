provider "google" {
  credentials = file(var.service_account_key_file)
  project = var.project_id
  region  = var.region
}


###############################################################################################

##############################################################################################

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-vm"
  machine_type = var.machine_type
  zone         = var.zone
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("C:/Users/XX/Desktop/GIT-add/Terraform-scripts/Jenkins-new/startup-scripts/jenkins-startup.sh")

}

resource "google_compute_instance" "sonarqube" {
  name         = "sonarqube-vm"
  machine_type = var.machine_type
  zone         = var.sonar-zone
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
  metadata_startup_script = file("C:/Users/XX/Desktop/GIT-add/Terraform-scripts/Jenkins-new/startup-scripts/sonarqube-startup.sh")

}

resource "google_compute_instance" "nexus" {
  name         = "nexus-vm"
  machine_type = var.machine_type
  zone         = var.zone
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
  metadata_startup_script = file("C:/Users/XX/Desktop/GIT-add/Terraform-scripts/Jenkins-new/startup-scripts/nexus-startup.sh")
  
}

resource "google_compute_instance" "monitor" {
  name         = "monitor-vm"
  machine_type = var.machine_type
  zone         = var.zone
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
  metadata_startup_script = file("C:/Users/XX/Desktop/GIT-add/Terraform-scripts/Jenkins-new/startup-scripts/Monitor.sh")

}



resource "google_container_cluster" "k8s_cluster" {
  name               = "my-k8s-cluster"
  location           = var.k8s_location
  project            = var.project_id

  initial_node_count = 2

  node_config {
    machine_type = "e2-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

}


# Create firewall rules to allow traffic to specified ports
resource "google_compute_firewall" "allow_jenkins_ports" {
  name    = "allow-jenkins-ports"
  project = var.project_id

  network = "default"

  allow {
    protocol = "tcp"
    ports    = [
      "8080",     # Jenkins
      "8081",     # Nexus
      "9000",     # Sonarqube
      "9090",     # Prometheus
      "3000",     # Grafana
      "9115",     # BlackBox Exporter
      "3000-10000", # Custom range
      "30000-32767", # Custom range
      "25",       # SMTP
      "465",      # SMTPS
      "6443"      # Kubernetes API
    ]
  }

  source_ranges = ["0.0.0.0/0"]
}
