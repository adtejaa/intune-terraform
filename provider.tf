terraform {
  required_providers {
    microsoft365wp = {
      source = "terraprovider/microsoft365wp"
      version = "0.16.0"
    }
  }
}


terraform { 
  cloud { 
    
    organization = "intune-adtejaa" 

    workspaces { 
      name = "intune-dev" 
    } 
  } 
}

# provider "microsoft365wp" {
#   client_id     = "pleae provide client_id"
#   client_secret = "please provide client_secret"
#   tenant_id     = "tenant_id"
#   use_oidc = true
# }
