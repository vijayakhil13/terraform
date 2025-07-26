terraform {
  backend "s3" {
    bucket = "vineeth-terraform-bucket2521"
    key = "terrform.tfstate"
    region="us-east-1"
    
    
  }
}