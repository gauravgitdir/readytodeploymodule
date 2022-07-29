data "aws_security_group" "postgresqlexample-sg" {
  id = var.db_security_group_name
}

resource "aws_vpc" "main" {
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "Main"
  }
}

resource "random_password" "rds_password" {
  length = 16
  special = false
}

resource "aws_secretsmanager_secret" "examplerdssecret" {
  name = var.secret_key
}
resource "aws_secretsmanager_secret_version" "secretValue" {
  secret_id     = aws_secretsmanager_secret.examplerdssecret.id
  secret_string = random_password.rds_password.result
}

resource "aws_route53_zone" "example" {
  name = var.dns_name
}

resource "aws_route53_record" "example" {
  allow_overwrite = true
  name            = aws_route53_zone.example.name
  ttl             = 172800
  type            = var.type
  zone_id         = aws_route53_zone.example.zone_id

  records = [
    aws_route53_zone.example.name_servers[0],
    aws_route53_zone.example.name_servers[1],
    aws_route53_zone.example.name_servers[2],
    aws_route53_zone.example.name_servers[3],
  ]
}

resource "aws_secretsmanager_secret" "secret-key-aws" {
  name                = "Secret-key"
}

locals {
  instance_count = var.instance_count
}

data "template_file" "kms_policy" {
  template = file("./resources/kms_policy.json.tpl")
  vars = {
    account_id = var.account_id
  }
}

resource "aws_kms_key" "exampleauthoringwebKMSKey" {
  description             = "A KMS key to encrypt the Aurora postgres database"
  policy                  = data.template_file.kms_policy.rendered
  tags = {
    Name = "AEA-KMS-Key"
    component = var.component
  }
}

resource "aws_kms_alias" "exampleauthoringwebKMSKeyAlias" {
  target_key_id = aws_kms_key.exampleauthoringwebKMSKey.key_id
}



resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.db_cluster_instance_name}-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.r4.large"
  engine             = var.db_engine
  engine_version     = aws_rds_cluster.default.engine_version
#  db_subnet_group_name = aws_db_subnet_group.examplepostgresql-subnet-group.name
   performance_insights_kms_key_id = aws_kms_key.exampleauthoringwebKMSKey.arn
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "${var.db_cluster_instance_name}-cluster"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name      = var.db_name
  master_username    = var.db_admin_username
  master_password    = var.db_admin_password
  vpc_security_group_ids  = [data.aws_security_group.postgresqlexample-sg.id]
#  db_subnet_group_name    = aws_db_subnet_group.examplepostgresql-subnet-group.name
  kms_key_id                      = aws_kms_key.exampleauthoringwebKMSKey.arn 
  enabled_cloudwatch_logs_exports = ["postgresql"]
  
}


resource "aws_cloudwatch_metric_alarm" "sa_example_freeable_memory" {
  alarm_name                = "terraform-Memory-Alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "sa_example_cpu_utilization" {
  alarm_name          = "terraform-CPU-Utilazation"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  unit                = "Percent"
  period              = 300
  evaluation_periods  = 2
  statistic           = "Average"
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
}


