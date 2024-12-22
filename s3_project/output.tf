output "s3_website_endpoint" {
    value = aws_s3_bucket_website_configuration.website.website_endpoint
  
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.static_bucket.arn
  
}