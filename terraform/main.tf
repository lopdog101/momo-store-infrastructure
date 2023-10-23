# Infrastructure for Yandex Cloud Managed Service for Kubernetes cluster
#
# Set the configuration of Managed Service for Kubernetes cluster
#
# Создание кластера Kubernetes в облаке Yandex.Cloud

# Set local variables
# Описание докальных переменных
locals {
  cloud_id              = "b1glnhfo1pb5aqli71pj"                      # Set your cloud Cloud ID.
                                                  # переменная для идентификатора облака
  zone_a_v4_cidr_blocks = "10.1.0.0/16"           # Set the CIDR block for subnet in the ru-central1-a availability zone.
                                                  # переменная для блока сетевых адресов кластера
  folder_id             = "b1g8tnrko4q1emhf9mqk"                      # Set your cloud folder ID.
                                                  # переменная для идентификатора каталога
  k8s_version           = "1.24"                  # Set the Kubernetes version.
                                                  # переменная для версии Kubernetes
  sa_name               = "sa-main"               # Set a service account name. It must be unique in a cloud.
                                                  # переменная для имени сервисного аккаунта от которорго будет создаваться кластер
}


# Set configuration for network
# Описание настроек сети для кластера 
resource "yandex_vpc_network" "k8s-net" {
  description = "Network for the Managed Service for Kubernetes cluster"
  name        = "k8s-network"
}

resource "yandex_vpc_subnet" "subnet-a" {
  description    = "Subnet in ru-central1-a availability zone"
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-net.id
  v4_cidr_blocks = [local.zone_a_v4_cidr_blocks]
}

# Set configuration for Security Groups 
# Описание настроек правил доступа к кластеру

resource "yandex_vpc_security_group" "k8s-main-sg" {
  description = "Group rules ensure the basic performance of the cluster. Apply it to the cluster and node groups."
  # Правила группы обеспечивают базовую работоспособность кластера. Примените ее к кластеру и группам узлов.
  name        = "k8s-main-sg"
  network_id  = yandex_vpc_network.k8s-net.id
  ingress {
    description    = "The rule allows availability checks from the load balancer's range of addresses. It is required for the operation of a fault-tolerant cluster and load balancer services."
    # Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика.
    protocol       = "TCP"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"] # The load balancer's address range
    predefined_target = "loadbalancer_healthchecks"
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    description       = "The rule allows the master-node and node-node interaction within the security group."
    # Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности.
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    description    = "The rule allows the pod-pod and service-service interaction. Specify the subnets of your cluster and services."
    # Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов.
    protocol       = "ANY"
    v4_cidr_blocks = [local.zone_a_v4_cidr_blocks]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    description    = "The rule allows receipt of debugging ICMP packets from internal subnets."
    # Правило разрешает отладочные ICMP-пакеты из внутренних подсетей.
    protocol       = "ICMP"
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 6443 port from specified network."
    # Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети.
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 443 port from specified network."
    # Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети.
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    description    = "The rule allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Object Storage, Docker Hub, and more."
    # Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д.
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Group rules allow connections to services from the internet. Apply the rules only for node groups."
  # Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов.
  network_id  = yandex_vpc_network.k8s-net.id

  ingress {
    protocol       = "TCP"
    description    = "Rule allows incoming traffic from the internet to the NodePort port range. Add ports or change existing ones to the required ports."
    # Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам.
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

# Create Service Account
# Создание сервисного аккаунта от которого будет создан кластер
resource "yandex_iam_service_account" "k8s-sa" {
  name = local.sa_name
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  # Assign "editor" role to service account.
  # назначение роли "editor" для сервисного аккаунта
  folder_id = local.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  # Assign "container-registry.images.puller" role to service account.
  # назначение роли "container-registry.images.puller" для сервисного аккаунта
  folder_id = local.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}

# Managed Service for Kubernetes cluster
resource "yandex_kubernetes_cluster" "k8s-cluster" {
  description = "Managed Service for Kubernetes cluster"
  name        = "k8s-cluster"
  network_id  = yandex_vpc_network.k8s-net.id

  master {
    version = local.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.subnet-a.zone
      subnet_id = yandex_vpc_subnet.subnet-a.id
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]

  }
  service_account_id      = yandex_iam_service_account.k8s-sa.id # Cluster service account ID
  node_service_account_id = yandex_iam_service_account.k8s-sa.id # Node group service account ID
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
}

resource "yandex_kubernetes_node_group" "k8s-node-group" {
  description = "Node group for the Managed Service for Kubernetes cluster"
  name        = "k8s-node-group"
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  version     = local.k8s_version

  scale_policy {
    auto_scale {
      min     = 1 # Minimum number of hosts
      max     = 4 # Maximum number of hosts
      initial = 1 # Initial number of hosts
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.subnet-a.zone
    }
  }

  instance_template {
    platform_id = "standard-v2" # Intel Cascade Lake

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.subnet-a.id]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id,yandex_vpc_security_group.k8s-public-services.id]
    }

    resources {
      memory = 8 # GB
      cores  = 4 # Number of CPU cores.
    }

    boot_disk {
      type = "network-hdd"
      size = 64 # GB
    }
  }
}