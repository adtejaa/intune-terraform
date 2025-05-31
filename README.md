# 🚀 Terraform Integration with Microsoft Intune & Entra ID using Service Principal and OIDC

This project enables you to manage Microsoft Intune and Entra ID (formerly Azure AD) using Terraform and the [`microsoft365wp`](https://registry.terraform.io/providers/terraprovider/microsoft365wp/latest/docs) provider. It supports both local execution using a client secret and secure GitHub Actions CI/CD using OpenID Connect (OIDC).

---

## ✅ Setup Summary

### 🔐 1. Create an App Registration (Service Principal)

- Go to: Microsoft Entra ID → **App registrations** → **+ New registration**
  - **Name**: Terraform
  - **Supported account type**: Accounts in this organizational directory only (Single tenant)
  - **Redirect URI**: Web (leave URI blank)
- After creation, save:
  - `Application (client) ID`
  - `Directory (tenant) ID`

---

### 🔑 2. Create a Client Secret (for local use)

- Go to **Certificates & secrets** → **+ New client secret**
- Set a name and expiry → Click **Add**
- Save the secret immediately (only shown once)

---

### 🔓 3. Assign Microsoft Graph API Permissions

Go to **API permissions** → **+ Add permission** → Microsoft Graph → **Application permissions**

Add the following permissions based on what you intend to manage:

| Permission Name                                  | Description                                   |
|--------------------------------------------------|-----------------------------------------------|
| `DeviceManagementApps.ReadWrite.All`             | Manage Intune apps                            |
| `DeviceManagementConfiguration.ReadWrite.All`    | Manage Intune device configs and policies     |
| `DeviceManagementServiceConfig.ReadWrite.All`    | Manage Intune settings                        |
| `Directory.ReadWrite.All`                        | Manage Entra ID directory objects             |
| `Group.ReadWrite.All`                            | Manage Entra ID groups                        |
| `Policy.ReadWrite.ConditionalAccess`             | Manage Conditional Access policies            |
| `User.ReadWrite.All`                             | Manage user objects                           |
| `CloudPC.ReadWrite.All`                          | Manage Windows 365 configurations             |

✅ Click **"Grant admin consent"**

---

### 🔁 4. Configure Federated Credentials (OIDC for GitHub Actions)

To use OIDC-based authentication from GitHub Actions:

- Go to **Certificates & secrets** → **Federated credentials**
- Click **+ Add credential**
- Fill:
  - **Scenario**: GitHub Actions deploying Azure resources
  - **Organization**: `your-org`
  - **Repository**: `your-repo`
  - **Entity type**: `Branch`
  - **Branch name**: `main`
  - **Name**: `github-main-oidc`
- Click **Add**

---

## ⚙️ Terraform Configuration

This repository uses the [`microsoft365wp`](https://registry.terraform.io/providers/terraprovider/microsoft365wp/latest) provider to manage Microsoft Intune and Entra ID resources. It uses **Terraform Cloud** to store and manage the remote state file, ensuring consistency between GitHub Actions and local executions.

---

### 📌 Why `client_id` and `tenant_id` Are Required (Even with OIDC)

- Even when using **OIDC-based authentication** (i.e. no secrets), Terraform still needs to **know which Azure App Registration to use**.
- `client_id`: Identifies the App Registration you created in Entra ID.
- `tenant_id`: Tells Terraform which Microsoft Entra tenant (directory) to authenticate against.
- `use_oidc = true`: Instructs Terraform to **request an identity token** from GitHub Actions and use that to authenticate against Azure.
- ✅ No `client_secret` is needed in OIDC mode.

---

### ☁️ Why Terraform Cloud Is Used

Terraform Cloud stores your `.tfstate` file remotely, enabling:

- ✅ **Shared access** between users and GitHub Actions
- ✅ **Drift detection**, **remote plan/apply**, and **state locking**
- ✅ Better security: no local `.tfstate` with sensitive data like `resource_ids`

Once configured, both **local CLI** and **GitHub workflows** interact with the same cloud state, avoiding duplication or drift.

> 💡 If you're using `terraform login` locally, your actions are also recorded in Terraform Cloud UI just like GitHub CI/CD.

---

### 🔧 `provider.tf`

#### ▶️ GitHub Actions (OIDC)

```hcl
terraform {
  required_providers {
    microsoft365wp = {
      source  = "terraprovider/microsoft365wp"
      version = "0.16.0"
    }
  }

  cloud {
    organization = "intune-adtejaa"

    workspaces {
      name = "intune-dev"
    }
  }
}

provider "microsoft365wp" {
  client_id = var.client_id
  tenant_id = var.tenant_id
  use_oidc  = true
}

provider "microsoft365wp" {
  client_id = var.client_id
  tenant_id = var.tenant_id
  use_oidc  = true
}


## 🔐 Authentication & State Handling Explained

This project supports two modes of authentication for managing Microsoft Intune and Entra ID via Terraform:

---

### 🔑 Required Credentials

| Credential        | GitHub OIDC (CI/CD) | Local Execution | Purpose                                                                 |
|------------------|---------------------|-----------------|-------------------------------------------------------------------------|
| `client_id`      | ✅ Required         | ✅ Required     | Identifies the Azure App Registration (Service Principal)              |
| `tenant_id`      | ✅ Required         | ✅ Required     | Specifies the Entra ID (Azure AD) tenant                               |
| `client_secret`  | ❌ Not Needed       | ✅ Required     | Required only for local runs to authenticate                           |

> 🔸 GitHub Actions uses **OIDC federation**, so you don't need to store `client_secret` in secrets.

---

### 📦 Terraform Cloud State

| Use Case                      | `TERRAFORM_CLOUD_TOKEN` | Why is it Needed?                                                         |
|------------------------------|--------------------------|---------------------------------------------------------------------------|
| Using Terraform Cloud        | ✅ Required               | Authenticates and stores state in Terraform Cloud (`.tfstate` file)       |
| Using Local State (Optional) | ❌ Not Required           | Uses `.tfstate` file on local filesystem                                  |

> ℹ️ Running `terraform login` locally connects your machine to Terraform Cloud and syncs state centrally.

---

### 🤝 Summary

- **GitHub Actions**:
  - Uses `client_id` + `tenant_id`
  - Uses OIDC via federated credentials
  - No need to store or expose client secrets
- **Local Machine**:
  - Requires `client_id`, `tenant_id`, and `client_secret`
  - State is still stored in Terraform Cloud (after login)


