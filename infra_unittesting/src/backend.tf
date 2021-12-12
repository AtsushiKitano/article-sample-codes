terraform {
  backend "gcs" {
    bucket = "article-sample-codes-terraform-statefiles"
    prefix = "infra-unittesting"
  }
}
