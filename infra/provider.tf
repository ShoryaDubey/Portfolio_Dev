provider "aws" {
  region = "us-east-1" 
}


provider "vault" {
  address = "http://3.90.161.156"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "7a4444f7-41d3-ba47-6afa-24fb08951912"
      secret_id = "a6f3da2b-cc18-fad4-0df0-a3f7c5b120e7"
    }
  }
}

