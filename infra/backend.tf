terraform {
  backend "s3" {
    bucket         = "terraformstate1853"
    key            = "dev/terraform.tfstate"  # unique path for state file
    region         = "us-east-1"
  }
}
