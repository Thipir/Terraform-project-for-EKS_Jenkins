terraform {

  backend "s3" {
    bucket = "jenkinseksbackend"
    key    = "jenkins_ec2/statefile.tf"
    region = "us-west-2"

  }
}