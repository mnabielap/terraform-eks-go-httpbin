# 🏭 Prod Environment (terraform/envs/prod)

This folder contains **example settings** for a **production-like** environment.

Just like the dev folder:

- It does **not** contain the full Terraform logic.
- It provides:
  - `terraform.tfvars` → variable values for prod
  - `backend.tf`       → example of a local backend path for prod state

The actual resources are defined in the parent `terraform` directory.

---

## 📂 Files in This Folder

- `backend.tf`  

  ```hcl
  terraform {
    backend "local" {
      path = "../../state/prod/terraform.tfstate"
    }
  }
  ```

This shows where you would store Terraform state for a prod environment if you choose to separate dev/prod state. In a real-world setup, you might move this into its own backend config or use S3 + DynamoDB instead.

* `terraform.tfvars`

  Contains settings tuned for a more “prod-like” setup, for example:

  * Different VPC CIDR (`10.1.0.0/16`)
  * Larger instance type (`t3.large`)
  * Larger node group size (e.g. 3 desired, 2 min, 5 max)
  * Same AWS region: `ap-southeast-1`

---

## ▶️ How to Apply Using Prod Variables

Again, the recommended simple usage is:

```bash
cd terraform
terraform init

terraform plan -var-file="envs/prod/terraform.tfvars"

terraform apply -var-file="envs/prod/terraform.tfvars"
```

This will:

* Use the main configuration (modules for network, IAM, EKS).
* Use **prod-style** values from `envs/prod/terraform.tfvars`.

---

## 🧹 Destroying Prod Environment

If you have created resources with the prod variables and want to delete them:

```bash
cd terraform
terraform destroy -var-file="envs/prod/terraform.tfvars"
```

This will destroy:

* VPC + subnets
* IAM roles
* EKS cluster + node group

> ⚠️ Be extremely careful when destroying prod-like environments in a real AWS account.

---

## 🧠 Mental Model

Think of this folder as:

> “Same blueprint as dev, but with **bigger machines and slightly different CIDR ranges**.”

The **blueprint** (modules, resources) is exactly the same.
Only the **inputs** (variables) change:

* Bigger capacity (e.g. `t3.large`)
* More nodes
* Different CIDR block

This is the classic pattern of **“same infrastructure, different parameters”** using Terraform.