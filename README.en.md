### sample-terraform-digitalocean

Educational repository to practice infrastructure-as-code, CI/CD and provisioning techniques: Terraform, Ansible, Docker and pipeline patterns (GitHub Actions). This repo was created for learning purposes and will be public for the community.

## Purpose

This project acts as a lab: a minimal application and infrastructure layout to practice and demonstrate continuous delivery and Infrastructure as Code (IaC) patterns. Main goals:

- Learn and apply Terraform (modules, variables, environment-specific tfvars).
- Automate provisioning and configuration with Ansible (playbooks and roles).
- Package the application with Docker and understand images/containers.
- Design CI/CD pipelines (build, tests, images, provisioning and deploy) with GitHub Actions in mind.

## Repository structure

Top-level:

- `app/` — example ASP.NET application with a `Dockerfile` and `.csproj` project.
- `infra/` — automation and provisioning code:
  - `ansible/` — playbooks, roles and templates (e.g. nginx, docker setup).
  - `terraform/` — Terraform configuration, modules and environment variable files.

Inside `terraform/` (summary):

- `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` — core configuration.
- `environments/` — `dev.tfvars`, `staging.tfvars`, `prod.tfvars` for environment-specific values.
- `modules/` — reusable modules (`droplet/`, `network/`, `ssh/`).

## Concepts and techniques covered

Terraform

- Use modules to compose reusable resources (separation of concerns: droplet, network, ssh).
- Practice variables and `tfvars` files for environments (dev/staging/prod).
- Recommend using a remote state backend (e.g., Terraform Cloud, S3/DO Spaces) for collaboration.

Ansible

- Playbooks and roles for idempotent server configuration (install Docker, configure Nginx, deploy app).
- Jinja2 templates to render configuration files (e.g. `nginx.conf.j2`).

Docker

- Dockerfile to package the .NET application and simplify local testing and CI.

CI/CD (GitHub Actions - concepts)

- Typical pipelines: CI (build, tests, static analysis), build Docker image, push to registry; CD (provision/update infra and deploy).
- Recommended strategy: run `terraform plan` on PRs and perform `terraform apply` from a protected `main` branch with human review (or automated guards).

Best practices

- Separation of concerns (infra vs configuration vs app).
- Don’t store secrets in plain text: use GitHub Secrets, HashiCorp Vault, or a secure backend.
- Validate changes locally before applying to real environments; inspect `terraform plan` and review diffs.

## How to use (quick examples)

Note: commands below are for PowerShell (Windows). Adjust for your shell/OS as needed.

1. Run the .NET application locally

```pwsh
cd .\app
dotnet build
dotnet run --project .\web-api.csproj
```

Or, using Docker (build and run locally):

```pwsh
cd .\app
docker build -t sample-web-api:local .
docker run --rm -p 5000:80 sample-web-api:local
```

2. Working with Terraform (infra)

Example for the `dev` environment (use variables/secrets appropriately):

```pwsh
cd .\infra\terraform
# set the DigitalOcean token in the environment (do NOT store the token in the repo)
$env:DIGITALOCEAN_TOKEN = "<your_token_here>"

terraform init
terraform validate
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

Recommendations:

- Configure a remote backend for Terraform state (Terraform Cloud, S3/DO Spaces, etc.) when working in teams.
- Use workspaces or separate directories per environment to isolate state.

3. Running Ansible (provisioning/configuration)

```pwsh
cd .\infra\ansible
# e.g. run a playbook to install Docker
ansible-playbook -i inventory.ini playbooks/setup-docker.yml --limit my-droplet
```

## Example pipeline ideas (suggestions)

- CI: on PR — checkout, restore/fetch dependencies, dotnet build, dotnet test, security scans, docker build, push to registry (optionally on main).
- CD: on merge to `main` — run `terraform plan` (apply after approval), `terraform apply` (post-review), then deploy app (Ansible/SSH or container update).

Store workflows under `.github/workflows/` (e.g. `ci.yml`, `cd.yml`).

## Minimal contract (inputs/outputs and error modes)

- Inputs: files under `terraform/` (main.tf, variables.tf, `environments/*.tfvars`), provider token (env var), application code in `app/`.
- Outputs: provisioned infrastructure (droplets, networks), build artifacts (Docker image), running applications.
- Error modes: missing/invalid credentials, remote state conflicts, provider quota limits, failing Ansible playbooks.

## Edge cases and cautions

- Concurrent `terraform apply` runs without a remote backend can corrupt the state.
- Always inspect `terraform plan` before applying in production.
- Never commit secrets; use GitHub Secrets and CI variables.
