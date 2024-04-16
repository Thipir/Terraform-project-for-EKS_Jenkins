terraform {

  backend "s3" {
    bucket = "jenkinseksbackend"
    key    = "EKS/statefile.tf"
    region = "us-west-2"

  }
}