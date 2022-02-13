terraform {
  backend "s3" {
    region  = "us-east-1"
    bucket  = "tf-state-k8s-backend"
    encrypt = "true"
    key     = "k8s.tfstate"
  }
}