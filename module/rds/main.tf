
resource "aws_db_subnet_group" "this" {
  name        = "${replace(lower(var.database_Name), " ", "-")}-sg-group"
  subnet_ids  = toset(var.subnets)
  description = "${replace(lower(var.database_Name), " ", "-")}-sg-group"

}


resource "aws_db_instance" "this" {
  identifier              = var.database_Name
  instance_class          = var.instance_class
  kms_key_id              = var.kms_key_id
  apply_immediately       = var.apply_immediately
  multi_az                = var.multi_az
  allocated_storage       = var.storage
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  db_subnet_group_name    = aws_db_subnet_group.this.name
 # deletion_protection     = true
  engine                  = var.engine
  engine_version          = var.engine_version
  final_snapshot_identifier           = "${replace(lower(var.database_Name), " ", "-")}-final-snapshot"
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  manage_master_user_password         = true
  master_user_secret_kms_key_id       = var.kms_key_id
  max_allocated_storage               = var.max_allocated_storage
  # maintenance_window                  = var.maintenance_window
  monitoring_interval    = var.monitoring_interval
  network_type           = var.network_type
  port                   = 3306
  storage_encrypted      = true
  storage_type           = var.storage_type
  tags                   = var.tags
  username               = "admin"
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
}

