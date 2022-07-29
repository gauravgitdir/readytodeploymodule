#---------------------------------------------------------------------------------------------------------
# This is called the variable file from where we pass the variable values to the main.tf terraform file.
#---------------------------------------------------------------------------------------------------------
account_id = 410533792414
instance_count = 2
instance_class = "db.t4g.large"
db_cluster_instance_name = "yashinsta"

db_engine = "aurora"

db_name = "yashdb"

db_security_group_name = "sg-001a06a7ba5ed16d7"


environment = "cert"

instance_count = 2

vpc_name = "defaultvpc"

freeable_threshold = 2

trans_wrap_threshold = 3

cidr_block = "10.0.0.0/16"

instance_tenancy = "default"

cidr_block_vpc = "10.0.1.0/24"

dns_name = "test.example.com"

type = "NS"

