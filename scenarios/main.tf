provider "aws" {
    region = "us-east-1"
  
}

import {
  id = "i-0147ca07130cfb118"
  to= aws_instance.my_instance
}
