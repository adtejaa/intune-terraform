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

### 🔹 Option A: Local (Client Secret)

```hcl
provider "microsoft365wp" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}
