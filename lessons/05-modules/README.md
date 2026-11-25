# Lesson 5: Modules (company-style repo layout)

modules/            reusable building blocks (no provider, no backend)
  data_lake/        S3 zone buckets + security settings
  spark_job_role/   IAM role for Spark with least-privilege S3 access
envs/
  dev/              root module for dev: provider, backend, module calls

Run from envs/dev:
  terraform init -backend-config=localstack.s3.tfbackend
  terraform plan -out=tfplan
  terraform apply tfplan
