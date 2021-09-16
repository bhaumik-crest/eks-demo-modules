data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-387859"
    key     = "us-east-2/dev/eks/terraform.tfstate"
    region  = "us-east-2"  
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "node-app"
    labels = {
      App = "NodeApp"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "NodeApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "NodeApp"
        }
      }
      spec {
        container {
          image = "bhaumik20/getting-started:latest"
          name  = "example"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "node-service" {
  metadata {
    name = "node-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
