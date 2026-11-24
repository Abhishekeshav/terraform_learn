# Read : a file owned by someone else . Terraform bever changes or deletes it.
data "local_file" "sales_schema" {
  filename = "${path.module}/input/sales_schema.json"
}

# Create : a file Terraform owns. It's in state ,and destroy removes it .
resource "local_file" "glue_table_sales" {
  filename = "${path.module}/output/glue_table_sales.json"

  content = jsonencode({
    database = "raw_db"
    table    = "sales"
    location = "s3://de-raw-example/sales/"
    format   = "parquet"
    columns  = jsondecode(data.local_file.sales_schema.content).columns
  })
}
