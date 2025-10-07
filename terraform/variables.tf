variable "region" { default = "ap-southeast-1" }
variable "environment" { default = "staging" }
variable "cluster_name" { default = "max-weather-cluster" }
variable "terraform_state_bucket" { description = "S3 bucket for state" }
variable "terraform_lock_table" { description = "DynamoDB table for locks" }