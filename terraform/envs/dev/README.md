# 🌱 Dev Environment (terraform/envs/dev)

This folder contains **example settings** for a **development-like** environment.

- It does **not** contain full Terraform configuration by itself.
- Instead, it provides:
  - `terraform.tfvars` → variable values for dev
  - `backend.tf`       → example of how you could configure a local backend for dev

The **main Terraform configuration** still lives in the parent folder: `../..` (the root `terraform` directory).

---

## 📂 Files in This Folder

- `backend.tf`  
  Example backend configuration using a local file:

  ```hcl
  terraform {
    backend "local" {
      path = "../../state/dev/terraform.tfstate"
    }
  }
  ```

> 📝 This shows how you might separate dev/prod state paths.
> For simplicity, you can also run Terraform directly from the root `terraform` folder without using this file.

* `terraform.tfvars`
  Variable values tuned for dev:

  * `environment = "dev"`
  * Smaller instance type (`t3.medium`)
  * Smaller desired node count (2)

---

## ▶️ How to Use Dev Variables with the Root Terraform Module

The recommended simple way is to run Terraform from the **root `terraform` directory** and tell it to use this `terraform.tfvars` file.

From repository root:

```bash
cd terraform
terraform init

terraform plan -var-file="envs/dev/terraform.tfvars"

terraform apply -var-file="envs/dev/terraform.tfvars"
```

This will:

* Use all the main configuration in `terraform/` (network, iam, eks modules).
* Use the dev-specific values from `envs/dev/terraform.tfvars`.

---

## 🧪 Testing with Dev-Like Settings

The Terraform tests in `terraform/tests/unit` also use similar-style inputs (CIDR ranges, AZs, etc.) to verify that:

* The EKS cluster outputs are not empty.
* The VPC and subnet IDs are not empty.

You can run tests like this:

```bash
cd terraform
terraform test
```

---

## 🧹 Destroying Dev Environment

To clean up the dev-style infrastructure:

```bash
cd terraform
terraform destroy -var-file="envs/dev/terraform.tfvars"
```

This will remove:

* VPC and subnets
* IAM roles
* EKS cluster and node group

> ⚠️ Always check the destroy plan carefully when running against a real AWS account.

---

## 🧠 Mental Model

You can think about this folder as:

> “A small file that tells Terraform:
> *Use the main configuration, but with these dev options and CIDR ranges*.”

The real intelligence (modules, resources) is in `terraform/main.tf`, `terraform/modules/*`, etc.
This folder just helps separate **dev configuration** from **prod configuration**.