# 🚀 Terraform EKS + go-httpbin

This repository contains a **self-contained example** of:

1. 🌐 Creating an **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform**
2. 🐳 Deploying the **go-httpbin** demo application to that cluster using **Kubernetes manifests**
3. 🌍 Exposing the app publicly via **Ingress** so it can be accessed from the internet

---

## 🧱 High-Level Architecture (Big Picture)

Imagine the architecture as **layers**:

```text
+------------------------------------------------------------+
|                     Internet Users                         |
+--------------------------+---------------------------------+
                           |
                           v
+------------------------------------------------------------+
|        Ingress (e.g. NGINX / ALB Ingress Controller)       |
|  - Routes HTTP requests (go-httpbin.example.com)           |
+--------------------------+---------------------------------+
                           |
                           v
+------------------------------------------------------------+
|      Kubernetes Service (ClusterIP, port 80 -> 8080)       |
|  - Stable name: go-httpbin                                 |
|  - Forwards traffic to Pods                                |
+--------------------------+---------------------------------+
                           |
                           v
+------------------------------------------------------------+
|         Pods running go-httpbin Deployment                 |
|  - Docker image: mccutchen/go-httpbin:latest               |
|  - Replicas: 2 (dev) / 3 (prod overlay)                    |
+------------------------------------------------------------+
                           |
                           v
+------------------------------------------------------------+
|                 Amazon EKS Cluster (Control Plane)         |
|  - Managed Kubernetes API                                  |
|  - Uses IAM cluster role                                   |
+------------------------------------------------------------+
                           |
                           v
+------------------------------------------------------------+
|              EC2 Worker Nodes (Managed Node Group)         |
|  - Node group managed by EKS                               |
|  - Uses IAM node role                                      |
+------------------------------------------------------------+
                           |
                           v
+------------------------------------------------------------+
|   VPC + Subnets + Internet Gateway (Network Layer)         |
|  - VPC CIDR (e.g. 10.0.0.0/16)                             |
|  - Public subnets (for public access)                      |
|  - Private subnets (for nodes, internal traffic)           |
|  - Internet Gateway for outbound + public access           |
+------------------------------------------------------------+
```

## 🗺️ Visual Architecture

For a detailed end-to-end architecture diagram of this project, please refer to:

👉 [visual-architecture.svg](https://raw.githubusercontent.com/mnabielap/terraform-eks-go-httpbin/refs/heads/master/visual-architecture.svg)

### 🔍 Main AWS Components

* **VPC (Virtual Private Cloud)**: Your isolated network inside AWS.
* **Public Subnets**: Subnets that have a route to the internet via an **Internet Gateway**.
* **Private Subnets**: Subnets without direct internet access (more secure for workloads).
* **Internet Gateway (IGW)**: Connects the VPC to the internet.
* **Security Group**:

  * Allows inbound `443` (HTTPS) to the EKS API endpoint **from anywhere** (for demo).
  * Allows traffic inside the group so nodes and control plane can talk.
* **IAM Roles**:

  * **Cluster role**: Permissions for the EKS control plane.
  * **Node role**: Permissions for EC2 worker nodes (pull images, talk to EKS, etc.).
* **EKS Cluster**:

  * Managed Kubernetes control plane.
  * Uses both public + private subnets.
* **Managed Node Group**:

  * EC2 worker nodes that join the EKS cluster.
  * Autoscaling with min / max / desired size.

---

## 📁 Repository Structure

```text
.
├── README.md                  # You are here: main documentation and quick start
├── LICENSE                    # MIT license
├── .gitignore                 # Ignore Terraform state, env files, etc.
├── Makefile                   # Helper targets for Terraform and kubeconfig
│
├── terraform/
│   ├── providers.tf           # AWS provider config
│   ├── versions.tf            # Terraform + provider versions
│   ├── main.tf                # Root module: wires network, IAM, and EKS modules
│   ├── variables.tf           # Root-level variables
│   ├── outputs.tf             # Root-level outputs (cluster info, kubeconfig, etc.)
│   │
│   ├── modules/
│   │   ├── network/           # VPC, subnets, internet gateway, routes
│   │   ├── iam/               # IAM roles for cluster and node group
│   │   └── eks/               # EKS cluster, managed node group, security group
│   │
│   ├── envs/
│   │   ├── dev/               # Example dev environment values
│   │   └── prod/              # Example prod environment values
│   │
│   └── tests/
│       ├── unit/              # Terraform test files
│       └── fixtures/          # Shared test fixture values
│
├── k8s/
│   ├── base/                  # Base Kubernetes manifests for go-httpbin
│   └── overlays/              # Kustomize overlays for dev and prod
│
├── scripts/                   # Helper shell scripts
│
└── .github/workflows/ci.yml   # GitHub Actions for Terraform + YAML validation
```

---

## 🧩 What Does Terraform Create?

At a high level, Terraform creates:

1. **Network (module `network`)**

   * 1 VPC
   * 2 public subnets
   * 2 private subnets
   * Internet Gateway
   * Public route table + associations

2. **IAM (module `iam`)**

   * EKS cluster IAM role + policy attachments
   * Node group IAM role + policy attachments

3. **EKS (module `eks`)**

   * EKS cluster
   * Security group for the cluster
   * Managed node group (EC2 worker nodes)
   * Data sources for cluster + auth token
   * A generated **kubeconfig** output

---

## ✅ Requirements (Tools You Need)

To actually run this end-to-end in a real AWS account, you need:

* 🏗️ [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.6.0`
* 🐚 A shell:

  * On Linux / macOS: `/bin/bash` works fine.
  * On Windows: recommended to use **Git Bash** or **WSL** for `.sh` scripts.
* 🧰 [kubectl](https://kubernetes.io/docs/tasks/tools/)
* 🧰 AWS CLI (optional but helpful)
* 🧪 (Optional) `terraform test` support (ships with modern Terraform)
* 🌐 An AWS account + credentials if you actually want to create the real resources
  (For assignment purposes, you do **not** need to run it – only the code is required.)

---

## ▶️ Quick Start: Create the EKS Cluster (dev-like settings)

This is the simplest way to run it using the **root Terraform module** and the **dev variable file**.

### 1. Clone the repository

```bash
git clone https://github.com/mnabielap/terraform-eks-go-httpbin.git
cd terraform-eks-go-httpbin
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Plan (using `envs/dev/terraform.tfvars`)

```bash
terraform plan -var-file="envs/dev/terraform.tfvars"
```

### 4. Apply

⚠️ This will create real resources in your AWS account (if you have credentials configured).

```bash
terraform apply -var-file="envs/dev/terraform.tfvars"
```

Terraform will:

* Print a plan
* Ask you to confirm (`yes`)
* Create the VPC, IAM roles, EKS cluster, and node group

When it finishes, it will show outputs such as:

* `cluster_name`
* `cluster_endpoint`
* `cluster_ca_certificate`
* `kubeconfig` (sensitive)

---

## 📄 Generating KUBECONFIG for `kubectl` (Very Important ✅)

The Terraform EKS module exposes a **`kubeconfig` output** that already contains:

* Cluster endpoint URL
* Certificate authority data
* Token (using AWS IAM auth)

You can turn this into a file like this (from repo root):

```bash
cd terraform
terraform output -raw kubeconfig > ../kubeconfig
cd ..
```

Now you have a file at `./kubeconfig`.

### 1. Set the `KUBECONFIG` environment variable

```bash
export KUBECONFIG="$(pwd)/kubeconfig"
```

### 2. Test connection with `kubectl`

```bash
kubectl get nodes
```

If everything is correct, you should see the worker nodes created by the managed node group.

---

## 🤖 Alternative: Using the Helper Script (Best-effort Demo)

There is also a helper script:

```bash
./scripts/generate-kubeconfig.sh
```

This script:

* Assumes an environment (default `dev`)
* Tries to run Terraform and write the kubeconfig to `./kubeconfig`

> 💡 For simplicity and full control, the **manual `terraform output` method** shown above is recommended, because it directly matches the `outputs.tf` in the root `terraform` module.

---

## 🐳 Deploying `go-httpbin` to the EKS Cluster

Once your cluster is up and your `KUBECONFIG` is configured, you can deploy the app.

### 1. Apply the base manifests using Kustomize overlay

For **dev overlay**:

```bash
# From repo root
kubectl apply -k k8s/overlays/dev
```

This will create:

* Namespace: `go-httpbin`
* Deployment: `go-httpbin` (with 2 replicas)
* Service: `go-httpbin` (ClusterIP on port 80)
* Ingress: `go-httpbin` (host: `go-httpbin.example.com`)
* ConfigMap: `go-httpbin-config`

For **prod overlay**:

```bash
kubectl apply -k k8s/overlays/prod
```

This is similar but:

* Uses `environment: prod` label
* Sets higher resource requests/limits
* Uses `replicas: 3`

### 2. Check that Pods are running

```bash
kubectl get pods -n go-httpbin
```

You should see something like:

```text
NAME                           READY   STATUS    RESTARTS   AGE
go-httpbin-xxxxxx-yyyyy        1/1     Running   0          2m
go-httpbin-xxxxxx-zzzzz        1/1     Running   0          2m
```

### 3. Check the Service and Ingress

```bash
kubectl get svc -n go-httpbin
kubectl get ingress -n go-httpbin
```

* The **Service** exposes port 80 internally.
* The **Ingress** routes HTTP requests to that service.

> ⚠️ To get real internet access, you must have an **Ingress Controller** installed in the cluster (e.g. nginx-ingress or AWS ALB Ingress Controller) and configure DNS (e.g. `go-httpbin.example.com`) to point to the public load balancer.

---

## 🧹 Cleaning Up (Destroying Resources)

When you are done, use Terraform to destroy the infrastructure.

```bash
cd terraform
terraform destroy -var-file="envs/dev/terraform.tfvars"
```

For a prod-style setup, use:

```bash
terraform destroy -var-file="envs/prod/terraform.tfvars"
```

⚠️ Always double-check the plan before confirming destruction, especially in a real AWS account.

---

## 🧪 Terraform Tests

In the `terraform/tests/unit` folder, there are **Terraform test files** (`.tftest.hcl`) that:

* Run `terraform plan` with sample variables
* Assert that certain **outputs are not empty** (e.g. `cluster_name`, `cluster_endpoint`, `vpc_id`)

You can run them from the `terraform` directory:

```bash
cd terraform
terraform test
```

---

## 🤝 CI with GitHub Actions

The file `.github/workflows/ci.yml` defines:

* A **Terraform job**:

  * `terraform fmt` (format check)
  * `terraform validate` for dev and prod
  * `terraform test`
* A **k8s-lint job**:

  * Downloads `yq`
  * Checks that all YAML files in `k8s/` are syntactically valid

This gives a basic quality gate for pull requests and pushes.

---

## 🧠 Summary (TL;DR)

* Terraform builds:

  * VPC + subnets + IGW
  * IAM roles
  * EKS cluster + node group + security group
* Terraform outputs a **ready-to-use `kubeconfig`** block.
* You write that to a file and use it with `kubectl`.
* Then you apply Kubernetes manifests via `kustomize` overlays to deploy **go-httpbin** and expose it with an **Ingress**.
* GitHub Actions + `terraform test` provide basic validation and testing.

You can read the environment-specific READMEs in:

* `terraform/envs/dev/README.md`
* `terraform/envs/prod/README.md`

for more environment-focused explanations. 😊
