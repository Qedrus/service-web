resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Remplace l'ACL par le contrôle d'ownership
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Configuration de l'accès public
resource "aws_s3_bucket_public_access_block" "my_bucket_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_policy     = false
  block_public_acls       = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Remplacement de aws_s3_bucket_object (déprécié) par aws_s3_object
resource "aws_s3_object" "public_example" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  key     = "public_example.txt"
  content = "This is a public object in the S3 bucket."

  depends_on = [aws_s3_bucket_public_access_block.my_bucket_access]
}

# Politique de bucket pour autoriser l'accès public aux objets
resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.my_bucket_access]

  bucket = aws_s3_bucket.my_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}