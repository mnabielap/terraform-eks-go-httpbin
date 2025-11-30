terraform {
  backend "local" {
    # Local backend is used to keep this project simple and self-contained.
    # You can later switch this to an S3 backend if you want remote state.
    path = "../../state/dev/terraform.tfstate"
  }
}
