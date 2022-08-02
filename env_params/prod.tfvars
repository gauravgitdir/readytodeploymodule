#---------------------------------------------------------------------------------------------------------
# This is called the variable file from where we pass the variable values to the main.tf terraform file.
#---------------------------------------------------------------------------------------------------------
account_id = your account id

secret_key = "your secret key"

instance_count = instance count number

instance_class = "instance class type"

db_cluster_instance_name = "cluster instance name"

db_engine = "engine name"

db_name = "database name"

db_security_group_name = "security group id"

environment = "your enviornment"

vpc_name = "your vpc name"

freeable_threshold = threshold number

trans_wrap_threshold =  threshold number

cidr_block = "cidr block"

instance_tenancy = " tenency of instance"

cidr_block_vpc = "vpc cidr block"

dns_name = " your DNS"

type = "type"

region  = "your region"

audit_auth_namespace = "your namespace"

instance_class = "instance class"

component = "component name"


display_name = "name"

topic = "topic name"

audit_auth_namespace = "namespace name"

sns_emails = "emai id"

sns_arn = "sns arn"

/*
  #---------------------------------------------------------------------------------------------------------
# This is called the variable file from where we pass the variable values to the main.tf terraform file.
#---------------------------------------------------------------------------------------------------------
environment = "env"
account_id = YOUR ID
assume_role_arn = "YOUR ROLE ARN"
hosted_record-set = "YOUR RECORD SET"
hosted_Zone_Name = "YOUR HOSTED ZONE NAME"
db_security_group_name = "YOUR SG"
db_subnet_group_name = "YOUR DB SG NAME"
subnet_prefix = "YOUR SUBNET PREFIX"
vpc_name = "VPC NAME"
db_instance_parameter_grp_name_cluster = "YOUR DB INSTANCE GRP NAME CLUSTER"
db_instance_parameter_grp_name_instance = "YOUR DB INSTANCE GRP NAME INSTANCE"
monitoring_interval= 60
monitoring_role_arn= "YOUR ROLE ARN"
secret_key = "YOUR SECRET KEY NAME"
topic = "YOUR TOPIC"
instance_class = "db.t4g.large"
cluster_deletion_snapshot = "YOUR CLUSTER SNAPSHOT NAME"
db_cluster_instance_name = "YOUR DB CLUSTER INSTNACE"
display_name = "YOUR DISPLAY NAME"
freeable_threshold = 524288000
trans_wrap_threshold = 10000000
audit_auth_filter_name = "YOUR FILTER NAME"
audit_auth_namespace = "YOUR NAMESPACE"
log_group_name = "YOUR LOG GROUP NAME"
db_event_subscription_name = ["YOUR SUBSCRIPTION NAME"]
instance_count = 1
*/
