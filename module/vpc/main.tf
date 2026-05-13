data "aws_region" "current" {}

data "aws_availability_zones" "this" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


resource "aws_vpc" "main-vpc" {
  cidr_block                       = var.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge({
    Name = "${replace(lower(var.project_name), " ", "-")}-VPC"
  }, var.tags)
}

resource "random_id" "s3_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket        = "${replace(lower(var.project_name), " ", "-")}-vpc-flow-logs-${lower(random_id.s3_suffix.hex)}"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id = "Retention-${var.flow-log-bucket-retention-days}-days"
    filter {}

    expiration {
      days = var.flow-log-bucket-retention-days
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled       = true
    blocked_encryption_types = ["SSE-C"]
  }

}


resource "aws_flow_log" "this" {
  log_destination      = aws_s3_bucket.this.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main-vpc.id
  log_format           = "$${version} $${account-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr}"
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-VPC-Flow-Logs"
  }

}

resource "aws_subnet" "public_subnets" {
  count             = length(data.aws_availability_zones.this.names)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, (count.index + 1) * 10)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  ipv6_cidr_block   = var.enable_ipv6 == true ? cidrsubnet(aws_vpc.main-vpc.ipv6_cidr_block, 8, count.index + 1) : null
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-Pub-${substr(data.aws_availability_zones.this.names[count.index], -2, -1)}"
  }

}


resource "aws_subnet" "private_subnets" {
  count             = length(data.aws_availability_zones.this.names)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, 10 * (count.index + 1 + length(data.aws_availability_zones.this.names)))
  ipv6_cidr_block   = var.enable_ipv6 == true ? cidrsubnet(aws_vpc.main-vpc.ipv6_cidr_block, 8, (count.index + 1 + length(data.aws_availability_zones.this.names))) : null
  availability_zone = data.aws_availability_zones.this.names[count.index]
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-Pvt-${substr(data.aws_availability_zones.this.names[count.index], -2, -1)}"
  }

}

resource "aws_eip" "eip" {
  count  = var.enable_nat == true ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-NAT-EIP"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-IGW"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat == true && var.nat_type == "gateway" ? 1 : 0
  allocation_id = aws_eip.eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_instance" "this" {
  count                       = var.enable_nat == true && var.nat_type == "instance" ? 1 : 0
  ami                         = var.nat_instance_ami
  instance_type               = var.nat_instance_type
  associate_public_ip_address = false
  disable_api_termination     = true
  force_destroy               = true
  enable_primary_ipv6         = var.enable_ipv6
  key_name                    = var.nat_instance_key_pair
  source_dest_check           = false
  iam_instance_profile        = var.nat_instance_profile
  user_data                   = <<-EOT
    #!/bin/bash

    sudo yum update -y

    sudo yum install iptables-services -y
    sudo systemctl enable iptables
    sudo systemctl start iptables

    echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/custom-ip-forwarding.conf
    sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

    net=$(ip route show default | awk '{print $5}')
    sudo /sbin/iptables -t nat -A POSTROUTING -o $net -j MASQUERADE
    sudo /sbin/iptables -F FORWARD
    sudo service iptables save
EOT
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.this.id]
  root_block_device {
    delete_on_termination = false
    encrypted             = true
    kms_key_id            = var.nat_ebs_kms
    volume_type           = "gp3"
    volume_size           = var.nat_ebs_volumn
  }
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-NAT-1a"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.enable_nat == true && var.nat_type == "instance" ? 1 : 0
  instance_id   = aws_instance.this[0].id
  allocation_id = aws_eip.eip[0].id
}


resource "aws_security_group" "this" {
  name   = "${replace(lower(var.project_name), " ", "-")}-NAT-SG"
  vpc_id = aws_vpc.main-vpc.id

  # lifecycle {
  #   create_before_destroy = true
  # }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main-vpc.cidr_block]
  }

  dynamic "ingress" {
    for_each = var.enable_ipv6 == true ? [1] : []

    content {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = [aws_vpc.main-vpc.ipv6_cidr_block]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = var.enable_ipv6 == true ? [1] : []

    content {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["::/0"]
    }
  }



}



resource "aws_egress_only_internet_gateway" "eigw" {
  count  = var.enable_nat == true && var.enable_ipv6 == true && var.nat_type == "gateway" ? 1 : 0
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-EIGW"
  }
}




resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  dynamic "route" {
    for_each = var.enable_ipv6 == true ? [1] : []
    content {
      ipv6_cidr_block = "::/0"
      gateway_id      = aws_internet_gateway.igw.id
    }


  }

  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-PUB-RT"
  }
}

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main-vpc.id

  dynamic "route" {
    for_each = var.enable_nat == true && var.nat_type == "gateway" ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }

  dynamic "route" {
    for_each = var.enable_nat == true && var.nat_type == "instance" ? [1] : []
    content {
      cidr_block           = "0.0.0.0/0"
      network_interface_id = aws_instance.this[0].primary_network_interface_id
    }
  }

  dynamic "route" {
    for_each = var.enable_ipv6 == true && var.enable_nat == true && var.nat_type == "instance" ? [1] : []
    content {
      ipv6_cidr_block      = "::/0"
      network_interface_id = aws_instance.this[0].primary_network_interface_id
    }
  }

  dynamic "route" {
    for_each = var.enable_nat == true && var.enable_ipv6 == true && var.nat_type == "gateway" ? [1] : []
    content {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_egress_only_internet_gateway.eigw[0].id

    }
  }


  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-PVT-RT"
  }
}


resource "aws_route_table_association" "pub-association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pvt-association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main-vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  route_table_ids   = [aws_route_table.private_rt.id, aws_route_table.public_rt.id]
  ip_address_type   = var.enable_ipv6 == true ? "dualstack" : "ipv4"
  tags = {
    Name = "${replace(lower(var.project_name), " ", "-")}-VPC-S3-GateWay-Endpoint"
  }
}


