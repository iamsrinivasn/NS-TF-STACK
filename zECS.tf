# Create a ECS Cluster
resource "aws_ecs_cluster" "webhost_ecs_cluster" {
  name = "webhost_ecs_cluster"
}

/* # Create a ECR Repository
resource "aws_ecr_repository" "webhost_ecr_repo" {
  name                 = "webhostrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
} */

