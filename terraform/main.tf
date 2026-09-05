resource "aws_instance" "netflix" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  # Security: do not assign a public IPv4 address directly to the instance.
  # Public access should be provided through an explicit network component
  # such as a load balancer or Elastic IP when required.
  associate_public_ip_address = false

  key_name = var.key_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "netflix-devsecops"
    Environment = "dev"
    Project     = "Netflix-DevSecOps"
    ManagedBy   = "Terraform"
  }
}
