resource "aws_lb" "this" {
  name                             = var.lb_name
  internal                         = var.private
  load_balancer_type               = var.lb_type
  enable_cross_zone_load_balancing = true
  ip_address_type                  = var.enable_ipv6 == false ? "ipv4" : "dualstack"
  security_groups                  = [var.lb_security_group_id]
  subnets                          = var.lb_type == "application" ? toset(var.lb_subnet_ids) : null

  access_logs {
    bucket  = var.lb_access_log_bucket_id
    enabled = true
    prefix  = var.lb_name
  }

  dynamic "subnet_mapping" {
    for_each = var.lb_type == "network" ? var.lb_subnet_ids : []
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.this[index(var.lb_subnet_ids, subnet_mapping.value)].id
    }
  }

  tags = var.tags
}


resource "aws_eip" "this" {
  count  = var.lb_type == "network" ? length(var.lb_subnet_ids) : 0
  domain = "vpc"

  tags = {
    "Name" = "${var.lb_name}-EIP"
  }
}


resource "aws_s3_bucket_policy" "this" {
  bucket = var.lb_access_log_bucket_id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com", "delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.lb_access_log_bucket_id}/*"
    ]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com", "delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.lb_access_log_bucket_id}"
    ]
  }
}
