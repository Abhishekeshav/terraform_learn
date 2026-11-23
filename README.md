# Terraform for Data Engineering: practice environment

A browser-based practice environment for the 4-week course. It opens in **GitHub Codespaces**, which is VS Code plus a Linux terminal running in your browser. Nothing gets installed on your laptop.

## What's inside

| Tool | Purpose |
|---|---|
| Terraform (latest) + tflint | The CLI and its linter |
| AWS CLI v2 | Talk to AWS, or to LocalStack |
| checkov | Security scanning for Terraform code |
| Docker | Runs LocalStack, a fake AWS, so you can practise without an AWS bill |
| VS Code Terraform extension | Autocomplete, formatting on save |

```
.devcontainer/          environment definition (what Codespaces installs)
scripts/                check-env, start/stop LocalStack
lessons/01-iac-workflow Lesson 1.1, no cloud needed
sandbox/localstack-check  smoke test for fake AWS (Day 3+)
```

## Step 1: Put this on GitHub (one time)

1. On github.com: **New repository** → name `terraform-de-practice` → **Private** → *Create repository* (leave it empty).
2. On the new repo page, click **uploading an existing file**.
3. Unzip the download, open the `terraform-de-practice` folder, select **everything inside it** (including the hidden `.devcontainer` folder and `.gitignore`), and drag it onto the page. On a Mac press `Cmd+Shift+.` to show hidden files; on Windows tick *View → Hidden items*.
4. Click **Commit changes**.

Check that `.devcontainer/devcontainer.json` shows up in the repo. Without it, Codespaces opens an empty default machine.

## Step 2: Open the codespace

On the repo page: **Code** (green button) → **Codespaces** tab → **Create codespace on main**.

The first build takes 3–5 minutes. When the terminal finishes, run:

```bash
./scripts/check-env.sh
```

You should see versions for terraform, aws cli, tflint, checkov and docker.

## Step 3: Do Lesson 1.1 (no cloud, no token)

```bash
cd lessons/01-iac-workflow
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Then do the assignment from the lesson (drift experiment, replacement experiment, reading the state file, destroy).

## Step 4 (from Day 3): fake AWS with LocalStack

LocalStack imitates AWS APIs inside your codespace, so `terraform apply` creates "S3 buckets" that cost nothing. Since March 2026 it needs a **free** token:

1. Sign up for the free **Hobby** plan at https://app.localstack.cloud and copy your auth token.
2. GitHub → your profile picture → **Settings → Codespaces → Secrets → New secret**
   - Name: `LOCALSTACK_AUTH_TOKEN`
   - Value: your token
   - Repository access: `terraform-de-practice`
3. Stop and restart the codespace so it picks up the secret.
4. Run:

```bash
./scripts/localstack-start.sh
cd sandbox/localstack-check
terraform init && terraform apply
aws --profile localstack s3 ls        # alias: awsl s3 ls
terraform destroy
```

**What LocalStack's free plan can't do:** EMR, Glue jobs, Redshift and MWAA are paid LocalStack features. For Week 3 we'll use a real AWS account in short apply → test → destroy sessions, with a budget alarm set.

## Using real AWS from the codespace (Week 3)

The AWS CLI is already installed. Run `aws configure sso` and follow the device-code link in your browser. Never paste access keys into code or commit them.

## Don't burn your free hours

- GitHub Free accounts get a monthly allowance of Codespaces compute and storage. A 2-core machine (the default here) uses it at 2 core-hours per hour.
- **Stop the codespace when you finish** (github.com/codespaces → ⋯ → Stop). It also stops by itself after 30 minutes idle.
- Delete old codespaces you no longer need, because storage counts too. Your code is safe as long as you've **committed and pushed** it.

## Saving your work

The codespace is a normal Git checkout:

```bash
git add .
git commit -m "Lesson 1.1 done"
git push
```

State files and `.terraform/` are ignored on purpose (see `.gitignore`).
