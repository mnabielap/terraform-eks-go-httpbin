terraform {
  backend "local" {
    # Local backend is used for simplicity.
    # In a real production setup this would normally be an S3 + DynamoDB backend.
    path = "../../state/prod/terraform.tfstate"
  }
}
