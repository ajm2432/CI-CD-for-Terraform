terraform {
  backend "s3" {
    bucket = "cedr-test"
    key    = "terraform.tfstate"
  }
}