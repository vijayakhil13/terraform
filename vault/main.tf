provider "aws" {
    region = "us-east-1"
}

provider "vault" {
    address = "https://34.227.117.160:8200"
    skip_child_token = true
    auth_login {
      path = "auth/approle/login"
      parameters = {
        role_id   = " 0cb17a5e-2516-3adc-c9fd-2d84b8510d2d"
        secret_id = " cae40902-fc7e-c395-563a-6a64ec2b3e22"
    }
}
}
data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "ubuntu" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"

  tags = {
    Secret = data.vault_kv_secret_v2.example.data["name"]
  }
}