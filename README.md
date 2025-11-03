# sample-terraform-digitalocean

Repositório didático para praticar conceitos e técnicas de infraestrutura como código, CI/CD e provisionamento: Terraform, Ansible, Docker, e pipelines (GitHub Actions). Este repositório foi criado para fins educacionais e será público para a comunidade.

## Objetivo

Este projeto serve como um laboratório: organizar infra e aplicação mínima para treinar e demonstrar padrões de entrega contínua e Infraestrutura como Código (IaC). Os pontos principais são:

- Aprender e aplicar Terraform (módulos, variáveis, arquivos por ambiente).
- Automatizar provisão e configuração com Ansible (playbooks e roles).
- Empacotar a aplicação com Docker e entender imagens/containers.
- Conceber pipelines de CI/CD (build, testes, imagens, provisionamento e deploy) - pensado para GitHub Actions.

## Estrutura do repositório

Top-level:

- `app/` — aplicação ASP.NET (exemplo) com `Dockerfile` e projeto `.csproj`.
- `infra/` — código de automação e provisão adicional:
  - `ansible/` — playbooks, roles e templates (ex.: nginx, docker setup).
  - `terraform/` — configuração Terraform, módulos e arquivos de variáveis por ambiente.

Dentro de `terraform/` (resumo):

- `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` — configuração principal.
- `environments/` — arquivos `dev.tfvars`, `staging.tfvars`, `prod.tfvars` com valores por ambiente.
- `modules/` — módulos reutilizáveis (`droplet/`, `network/`, `ssh/`).

## Conceitos e técnicas abordadas

Terraform

- Uso de módulos para compor recursos reutilizáveis (separação por responsabilidade: droplet, network, ssh).
- Prática de variáveis e arquivos de `tfvars` para ambientes (dev/staging/prod).
- Recomenda-se uso de remote state (ex.: backend S3/DO Spaces, Terraform Cloud) para colaboração.

Ansible

- Playbooks e roles para configuração idempotente de servidores (instalar Docker, configurar Nginx, deploy de app).
- Templates Jinja2 para gerar arquivos de configuração (ex.: `nginx.conf.j2`).

Docker

- Dockerfile para empacotar a aplicação .NET e facilitar testes locais e CI.

CI/CD (GitHub Actions - conceitos)

- Pipelines típicos: CI (build, testes, análise estática), build de imagem Docker, push para registry; CD (provisionamento/atualização infra e deploy).
- Estratégia recomendada: `terraform plan` em PRs, `terraform apply` em branch protegida `main` com revisão humana (ou automation com guard rails).

Boas práticas

- Segregação de responsabilidades (infra vs configuração vs app).
- Não guardar segredos em texto: usar GitHub Secrets, HashiCorp Vault, ou backend seguro.
- Testar localmente antes de aplicar em ambientes reais; validar `terraform plan` e revisar diffs.

## Como usar (exemplos rápidos)

Observação: os comandos abaixo são para PowerShell (Windows). Ajuste conforme seu shell/OS.

1. Executar a aplicação .NET localmente

```pwsh
cd .\app
dotnet build
dotnet run --project .\web-api.csproj
```

Ou, usando Docker (build e run locais):

```pwsh
cd .\app
docker build -t sample-web-api:local .
docker run --rm -p 5000:80 sample-web-api:local
```

2. Trabalhando com Terraform (infra)

Exemplo para ambiente `dev` (use variáveis/segredos adequadamente):

```pwsh
cd .\infra\terraform
# configurar token do DO no ambiente (não coloque o token no repo)
$env:DIGITALOCEAN_TOKEN = "<seu_token_aqui>"

terraform init
terraform validate
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

Recomendações:

- Configure um backend remoto para o estado (por exemplo, Terraform Cloud, S3/DO Spaces) quando trabalhar em equipe.
- Use workspaces ou pastas separadas por ambiente para isolar estados.

3. Executando Ansible (provisionamento/configuração)

```pwsh
cd .\infra\ansible
# Ex.: rodar playbook de instalação do Docker
ansible-playbook -i inventory.ini playbooks/setup-docker.yml --limit my-droplet
```

## Exemplos de pipelines (sugestão)

- CI: ao abrir PR — checkout, restore/pull de dependências, dotnet build, dotnet test, security scans, docker build, push to registry (optionally on main).
- CD: ao merge na `main` — terraform plan (aplicar se aprovado), terraform apply (pós revisão), deploy app (Ansible/SSH ou atualização via container orchestrator).

Você pode armazenar essas pipelines em `.github/workflows/` (ex.: `ci.yml`, `cd.yml`).

## Contrato mínimo (inputs/outputs e modos de erro)

- Inputs: arquivos em `terraform/` (main.tf, variables.tf, `environments/*.tfvars`), token de provedor (variável de ambiente), código da aplicação em `app/`.
- Outputs: infraestrutura provisionada (droplets, redes), artefatos de build (imagem Docker), aplicativos em execução.
- Modos de erro: credenciais ausentes ou inválidas, conflitos de estado remoto, limites de quota do provedor, falhas em playbooks Ansible.

## Casos de borda e cuidados

- Execuções simultâneas de `terraform apply` sem backend remoto podem causar corrupção de estado.
- Sempre valide `terraform plan` antes de aplicar em produção.
- Não incluir secrets em commits; usar GitHub Secrets e variáveis de CI.
