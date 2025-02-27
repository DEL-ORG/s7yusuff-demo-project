# Terraform backend configuration
/*terraform {
  backend "s3" {
    bucket         = "dev-blueops-jurist-tf-state"
    key            = "records/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "dev-blueops-jurist-tf-state-lock"
    encrypt        = true
  }
}
*/