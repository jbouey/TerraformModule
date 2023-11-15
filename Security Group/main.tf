# main.tf

resource "aws_security_group" "alb_security_group" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  // Ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  // Egress (outbound) rules
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "bastion_security_group" {
  name        = "${var.project_name}-${var.environment}-bastion-sg"
  description = "enable ssh access on port 22"
  vpc_id      = var.vpc_id

  // Ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  // Egress (outbound) rules
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "app_server_security_group" {
  name        = "${var.project_name}-${var.environment}-app-server-sg"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  // Ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_security_group.id]
    }
  }
    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_security_group.id]
    }
  }
  

  // Egress (outbound) rules
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "${var.project_name}-${var.environment}-database-sg"
  description = "enable mysql/aurora access port 3306"
  vpc_id      = var.vpc_id

  // Ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      security_groups = [aws_security_group.app_server_security_group.id]
    }
  }


  // Ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      security_groups = [aws_security_group.bastion_security_group.id]
    }
  }

  // Egress (outbound) rules
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

