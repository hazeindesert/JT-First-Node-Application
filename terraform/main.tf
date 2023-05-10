module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-tf-jt"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    ecs-tf-jt = {
      cpu    = 1024
      memory = 4096

      # Container definition(s)
      container_definitions = {
          
        ecs-sample = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "public.ecr.aws/docker/library/httpd:latest"
          port_mappings = [
            {
              name          = "ecs-sample"
              containerPort = 8080
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false
        }
      }
      
      assign_public_ip = true
      deployment_minimum_healthy_percent = 100
      subnet_ids = ["subnet-0c236aa7db587a815", "subnet-0b442c55bfcaef886", "subnet-0860c289a56da0f08"]
      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = 0
          to_port                  = 0
          protocol                 = "-1"
          description              = "Service port"
          cidr_blocks = ["0.0.0.0/0"]
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}