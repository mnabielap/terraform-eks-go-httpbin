# 🧪 Terraform Unit Tests (terraform/tests/unit)

This folder contains **Terraform test files** (`.tftest.hcl`) that verify basic expectations about the infrastructure.

The idea is:

> “Run `terraform plan` with some sample inputs and **assert** that important outputs are not empty.”

This is not a full-blown integration test, but it already gives quick feedback if something is broken.

---

## 📂 Files in This Folder

1. `eks_cluster_test.tftest.hcl`  
   - Creates a plan for the root module with test values.
   - Asserts that:
     - `output.cluster_name` is not empty.
     - `output.cluster_endpoint` is not empty.
     - `output.cluster_ca_certificate` is not empty.

2. `network_module_test.tftest.hcl`  
   - Also uses the root module with test values.
   - Asserts that:
     - `output.vpc_id` is not empty.
     - `output.public_subnet_ids` has at least 1 element.
     - `output.private_subnet_ids` has at least 1 element.

3. (Optional example) `../fixtures/sample_fixture.hcl`  
   - Contains example/shared variable values that could be reused by multiple tests.

---

## ▶️ How to Run the Tests

From the `terraform` directory:

```bash
cd terraform
terraform test
```

Terraform will:

1. Look at the files under `tests/unit/*.tftest.hcl`.
2. For each `run` block:

   * Use the root module (`source = "../.."`).
   * Apply the `variables` defined inside the test file.
   * Execute a `plan`.
   * Evaluate each `assert` block.

If an assertion fails, you will see an error message such as:

```text
Error: EKS cluster name output must not be empty.
```

---

## 🧠 Why These Tests Matter (Even If They Are Simple)

Even these very basic checks are useful because they verify:

* The configuration is at least **syntactically valid**.
* The main **outputs are wired correctly**:

  * If you accidentally rename an output
  * Or forget to export something from a module

…then the tests will fail.

This is especially helpful when combined with **CI (GitHub Actions)**:

* On each pull request or commit, the CI can:

  * Run `terraform fmt`
  * Run `terraform validate`
  * Run `terraform test`

If any of those steps fail, the PR shows a failing status.

---

## 🧩 Extending the Tests (Ideas)

Here are ideas for more advanced tests you could add:

* Assert that the EKS version equals a specific expected version (e.g. `"1.30"`).
* Assert that the number of public subnets equals `2`.
* Assert that node group size is within allowed limits.
* Assert that tags contain certain keys (`Project`, `Environment`, etc.).

Example of an additional assertion you could add:

```hcl
assert {
  condition     = length(output.public_subnet_ids.value) == 2
  error_message = "Expected exactly 2 public subnets."
}
```

---

## 🧠 Summary

* The files in this folder are **safety nets**.
* They ensure that the **most important outputs exist** and look sane.
* They are easy to run (`terraform test`) and integrate nicely with CI.

They do not replace full integration tests or manual checks, but they are a very lightweight and helpful starting point. 💡