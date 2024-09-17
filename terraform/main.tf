provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "ken-tf-state-bucket"
    key    = "terraform/gcc-technical-assignment/key"
    region = "ap-southeast-1"
  }
}
