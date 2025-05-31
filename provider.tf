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

provider "microsoft365wp" {
  client_id     = var.client_id
  tenant_id     = var.tenant_id
  use_oidc      = true
  use_cli       = false
}
