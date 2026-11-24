output "column_count" {
  value = length(jsondecode(data.local_file.sales_schema.content).columns)
}

output "column_names" {
  value = [for c in jsondecode(data.local_file.sales_schema.content).columns : c.name]
}
