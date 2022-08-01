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

/*data "aws_route53_zone" "sa_route53_zone_existing" {
  name         = var.hosted_Zone_Name
  private_zone = true
}
# record set for rds-postgres created in existing domain
resource "aws_route53_record" "sa_example-rds-recordSet" {
  zone_id = data.aws_route53_zone.sa_route53_zone_existing.zone_id
  name    = var.hosted_record-set
  type    = "CNAME"
  ttl     = var.route53_record_ttl
  records = [aws_rds_cluster.example-postgresql-cluster.endpoint]
}
/*

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

/* resource "aws_db_event_subscription" "sa_example_DBEventSubscription" {
  count = local.instance_count
  enabled          = true
  event_categories = ["configuration change", "failure","deletion","availability","backup","failover","maintenance","notification","read replica","recovery","low storage"]
  name             = var.db_event_subscription_name[count.index]
  sns_topic        = aws_sns_topic.example-sns-topic.arn
  source_ids       = [aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]]
  source_type      = "db-instance"

  tags = {
    Name = var.db_event_subscription_name[count.index]
    component = var.component
  }

  depends_on = [aws_sns_topic.example-sns-topic]
}
*/

/*
  
# CPU_Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "sa_example_cpu_utilization" {
  count = local.instance_count
  alarm_name          = "rds-${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}-CPU"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  unit                = "Percent"
  period              = 300
  evaluation_periods  = 2
  statistic           = "Average"
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_description = "RDS CPU Utilization for RDS aurora cluster ${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}"
  alarm_actions     = [aws_sns_topic.example-sns-topic.arn]
  insufficient_data_actions = [aws_sns_topic.example-sns-topic.arn]
  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.example-postgresql-cluster.cluster_identifier
  }
  tags = {
    Name = "serviceadvisor_example_cpu_utilization"
    component = var.component
  }
}
# Freeable Memory Alarm
resource "aws_cloudwatch_metric_alarm" "sa_example_freeable_memory" {
  count = local.instance_count
  alarm_name          = "rds-${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}-FreeableMemory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  unit                = "Bytes"
  period              = 300
  statistic           = "Average"
  threshold           = var.freeable_threshold
    alarm_description = "RDS freeable memory for RDS aurora cluster ${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}"
  alarm_actions     = [aws_sns_topic.example-sns-topic.arn]
  insufficient_data_actions        = [aws_sns_topic.example-sns-topic.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.example-postgresql-cluster.cluster_identifier
  }
  tags = {
    Name = "serviceadvisor_example_freeable_memory"
    component = var.component
  }
}

resource "aws_cloudwatch_metric_alarm" "sa_example_trans_Wrap" {
  count = local.instance_count
  alarm_name          = "rds-${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}-transwap"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "MaximumUsedTransactionIDs"
  unit                = "Count"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.trans_wrap_threshold
  alarm_description = "RDS swap usage for RDS aurora cluster ${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}"
  alarm_actions     = [aws_sns_topic.example-sns-topic.arn]
  insufficient_data_actions    = [aws_sns_topic.example-sns-topic.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.example-postgresql-cluster.cluster_identifier
  }
  tags = {
    Name = "serviceadvisor_example_trans_Wrap"
    component = var.component
  }
}
#--------------------------------------------
# LogGroup
#--------------------------------------------
## Keep LogGroup name in patteren /aws/rds/example-cluster/<cluster_name>/<item>,
## even if we specify different log group it will create default LogGroup additionally in above pattern and,
## logs will be redirected to default LogGroup
resource "aws_cloudwatch_log_group" "example-postgresql-LogGroup-postgresql" {
  name = var.log_group_name
  retention_in_days = 7

  tags = {
    Name = "diagnostics-example-postgresql-LogGroup"
    component = var.component
  }
}
# Audit filters and alarms
resource "aws_cloudwatch_log_metric_filter" "example_auth_audit_filter" {
  name           = var.audit_auth_filter_name
  pattern        = "authentication failed for user"
  log_group_name = aws_cloudwatch_log_group.example-postgresql-LogGroup-postgresql.name
  metric_transformation {
    name      = "FailedAuthCount"
    namespace = var.audit_auth_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "sa_example_auth_audit_alarm" {
  count = local.instance_count
  alarm_name          = "rds-${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}-AuthAuditAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 12
  metric_name         = "FailedAuthCount"
  #unit                = "Count"
  namespace           = var.audit_auth_namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data = "notBreaching"
  datapoints_to_alarm = 1
  alarm_description = "RDS swap usage for RDS aurora cluster ${aws_rds_cluster_instance.example-postgresql-instance.*.id[count.index]}"
  alarm_actions     = [aws_sns_topic.example-sns-topic.arn]
  insufficient_data_actions    = [aws_sns_topic.example-sns-topic.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.example_auth_audit_filter]
  
  tags = {
    Name = "serviceadvisor_example_auth_audit_alarm"
    component = var.component
  }

}
*/
/*
  resource "aws_db_parameter_group" "examplepostgresql-instance-param-grp" {
  name                          = var.db_instance_parameter_grp_name_instance
  family                        = var.db_family
  description                   = "Parameter group for Amazon Aurora Postgres DB"
  parameter {
    name = "log_connections"
    value = "1"
  }
  parameter {
    name = "log_disconnections"
    value = "1"
  }
  parameter {
    name = "log_statement"
    value = "none"
  }
  parameter {
    name = "log_duration"
    value = "0"
  }
  parameter {
    name = "log_min_duration_statement"
    value = "10"
  }
  parameter {
    name = "log_hostname"
    value = "0"
  }

  tags = {
    Name = var.db_instance_parameter_grp_name_instance
    component = var.component
  }
}
*/
