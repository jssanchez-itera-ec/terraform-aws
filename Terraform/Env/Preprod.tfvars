### Providers ###
aws_credentials = {
    aws_region    = "eu-south-2"  
    profile       = "genia"
    path = "terraform-preprod.tfstate"
}

### Networking ###

vpc = {
    vpc-preprod ={
        cidr_block = "10.120.220.0/22"
    }
}

private_subnets = {
  subnet-preprod-pvt-a = {
    vpc_name            = "vpc-preprod"
    cidr_block          = "10.120.220.0/24"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = false
  }
  subnet-preprod-pvt-b = {
    vpc_name            = "vpc-preprod"
    cidr_block         = "10.120.221.0/24"
    availability_zone   = "eu-south-2b"
    map_public_ip_on_launch = false
  }
  subnet-preprod-pvt-c = {
    vpc_name            = "vpc-preprod"
    cidr_block         = "10.120.222.0/24"
    availability_zone   = "eu-south-2c"
    map_public_ip_on_launch = false
 }
}

public_subnets = {
  subnet-preprod-pub-a = {
    vpc_name            = "vpc-preprod"
    cidr_block          = "10.120.223.0/26"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = true
  }
  #subnet-preprod-public-b = {
  #  vpc_name            = "vpc-preprod"
  #  cidr_block         = "10.120.221.0/24"
  #  availability_zone   = "eu-south-2b"
  #  map_public_ip_on_launch = false
  #}
  #subnet-preprod-public-c = {
  #  vpc_name            = "vpc-preprod"
  #  cidr_block         = "10.120.222.0/24"
  #  availability_zone   = "eu-south-2c"
  #  map_public_ip_on_launch = false
  #}
}

eip = {
  eip-preprod-nat-prod-a ={}
}

internet_gateway = {
  igw-preprod = {
    vpc_name              = "vpc-preprod"
  }
}

nat = {
  nat-preprod-pvt-a = {
    connectivity_type     = "public"
    allocation_id         = "eip-preprod-nat-prod-a"
    subnet_id             = "subnet-preprod-pub-a"
  }
}

route_table = {
  rtbl-preprod-pvt-subnets = {
    vpc_name               = "vpc-preprod"
    route_table_name       = "rtbl-preprod-pvt-subnets"
  }
  rtbl-preprod-pub-subnets = {
    vpc_name               = "vpc-preprod"
    route_table_name       = "rtbl-preprod-pub-subnets"
  }
}

private_routes = {
  rtbl-preprod-pvt-subnets={
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_name       = "nat-preprod-pvt-a"
  }
}

public_routes ={
  rtbl-preprod-pub-subnets={
    destination_cidr_block = "0.0.0.0/0"
    igw_name = "igw-preprod"
  }  
}

route_table_association_pvt = {
  association_1 = {
    subnet_name              = "subnet-preprod-pvt-a"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-preprod-pvt-b"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-preprod-pvt-c"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }  
}

route_table_association_pub = {
  association_1 = {
    subnet_name              = "subnet-preprod-pub-a"
    route_table_name         = "rtbl-preprod-pub-subnets"
  }
}
### SG EKS ###

security_groups = {
  sg_eks_preprod_genia = {
    vpc_name         = "vpc-preprod"
    description_rule = "Security group Cluster EKS"
    cidr_blocks_in   = ["0.0.0.0/0"]
    from_port_in     = 443
    to_port_in       = 443
    protocol_in      = "tcp"
    from_port_out    = 0
    to_port_out      = 0
    protocol_out     = "-1"
    cidr_blocks_out  = ["0.0.0.0/0"]
  }
  sg_rds_preprod_genia = {
    vpc_name         = "vpc-preprod"
    description_rule = "Security group Cluster EKS"
    cidr_blocks_in   = ["10.120.220.0/22", "10.110.0.0/24"]
    from_port_in     = 3306
    to_port_in       = 3306
    protocol_in      = "tcp"
    from_port_out    = 0
    to_port_out      = 0
    protocol_out     = "-1"
    cidr_blocks_out  = ["0.0.0.0/0"]
  }    
}

### EKS Cluster ###

eks = {
  eks-preprod-genaia = {
    name                    = "eks-preprod-genaia"
    role_arn                = "arn:aws:iam::105054799343:role/EKSGENAIAClusterRole"
    vpc_name                = "vpc-preprod"
    cluster_security_group_id = "sg_cluster_eks"
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
    version-eks             = "1.28"
    subnet_name-a           ={
      subnet_name = "subnet-preprod-pvt-a"
    }
    subnet_name-b           ={
      subnet_name = "subnet-preprod-pvt-b"
    }
    subnet_name-c           ={
      subnet_name = "subnet-preprod-pvt-c"
    }
    authentication_mode      = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
    
  }
}

eks-addon ={
    addon_1 = {
      addon_name            =  "vpc-cni"
      cluster_name          =  "eks-preprod-genaia"
    }
    #addon_2 = {
    #  addon_name            =  "coredns"
    #  cluster_name           =  "eks-preprod-genaia"      
    #}       
    addon_3 = {
      addon_name            =  "kube-proxy"
      cluster_name          =  "eks-preprod-genaia"
    }  
    addon_4 = {
      addon_name            =  "eks-pod-identity-agent"
      cluster_name          =  "eks-preprod-genaia"
    }                
}

eks-nodes = {
  m7i_2xlarge = {
    cluster_name    = "eks-preprod-genaia"
    #node_group_name = "eks-preprod-genaia-nodes"
    node_role_arn   = "arn:aws:iam::105054799343:role/AmazonEKSNodeRole_prod"
    ami_type        = "AL2_x86_64" #Amazon Linux 2
    capacity_type   = "ON_DEMAND" 
    disk_size       = "50"
    instance_types  = ["m7i.2xlarge"] # 8 CPU / 32 RAM
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-preprod-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-preprod-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-preprod-pvt-c"
      }
    }
    desired_size    = 1
    max_size        = 1
    min_size        = 1
    max_unavailable = 1
  }
}

subnet_group = {
  db_subnet_preprod_pvt ={
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-preprod-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-preprod-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-preprod-pvt-c"
      }
    }
  }
}

rds ={
  rdspreprodgenaia = {
    db_name= "wordpress"
    db_subnet_group_name = "db_subnet_preprod_pvt"
    allocated_storage = "40"
    max_allocated_storage = "200"
    engine = "MariaDB"
    engine_version = "10.11.6"
    instance_class = "db.t3.medium"
    multi_az = "false"
    username = "admin"
    password = "QGj4871qe#u7uDiw"
    parameter_group_name = ""
    vpc_security_group_ids = ""
    skip_final_snapshot = "true"
    backup_retention_period     = 7
    backup_window = "01:00-02:00"
    publicly_accessible = "false"
    vpc_security_group_ids = "sg_rds_preprod_genia"
  }
}

backup-vault = {
  rds-preprod-genaia={
    kms_key_arn = "arn:aws:kms:eu-south-2:105054799343:key/41aa3c56-7c43-40aa-a61c-36554f781d72"
  }
}

backup-plan =  {
  rds-genaia-preprod-daily= {
    rule_name         = "Daily-7days-Retention"
    target_vault_name = "rds-preprod-genaia"
    schedule          = "cron(0 1 * * ?)"
    delete_after = 7
  }
  rds-genaia-preprod-week= {
    rule_name         = "Week-1mouth-Retention"
    target_vault_name = "rds-preprod-genaia"
    schedule          = "cron(0 2 ? * 1)"
    delete_after = 30
  }  
}

backup-selection = {
  Daily-7days-Retention= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-preprod-genaia"
    plan_id              = "rds-genaia-preprod-daily"
    db_rds               = "rdspreprodgenaia"
  }
  rds-genaia-preprod-week= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-preprod-genaia"
    plan_id              = "rds-genaia-preprod-week"
    db_rds               = "rdspreprodgenaia"
  }    
}