terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}


resource "aws_s3_bucket" "static_bucket" {
  bucket = "project-s3-website-endpoint"
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.static_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_bucket.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_bucket.id

  index_document {
    suffix = "index.html"
  }
}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_bucket.bucket
  source       = "./index.html"
  key          = "index.html"
 
  content_type = "text/html"
}


resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.static_bucket.bucket
  source       = "./styles.css"
  key          = "styles.css"

  content_type = "text/css"
}

