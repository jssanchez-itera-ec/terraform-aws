### Providers ###
aws_credentials = {
    aws_region    = "eu-south-2"  
    profile       = "genia"
}

### Networking ###

vpc = {
    vpc-prod ={
        cidr_block = "10.120.224.0/22"
    }
}

private_subnets = {
  subnet-prod-pvt-a = {
    vpc_name            = "vpc-prod"
    cidr_block          = "10.120.224.0/24"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = false
  }
  subnet-prod-pvt-b = {
    vpc_name            = "vpc-prod"
    cidr_block         = "10.120.225.0/24"
    availability_zone   = "eu-south-2b"
    map_public_ip_on_launch = false
  }
  subnet-prod-pvt-c = {
    vpc_name            = "vpc-prod"
    cidr_block         = "10.120.226.0/24"
    availability_zone   = "eu-south-2c"
    map_public_ip_on_launch = false
 }
}

public_subnets = {
  subnet-prod-pub-a = {
    vpc_name            = "vpc-prod"
    cidr_block          = "10.120.227.0/26"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = true
  }
  subnet-prod-pub-b = {
    vpc_name            = "vpc-prod"
    cidr_block         = "10.120.227.64/26"
    availability_zone   = "eu-south-2b"
    map_public_ip_on_launch = true
  }
  subnet-prod-pub-c = {
    vpc_name            = "vpc-prod"
    cidr_block         = "10.120.227.128/26"
    availability_zone   = "eu-south-2c"
    map_public_ip_on_launch = true
  }
}

eip = {
  eip-prod-nat-prod-a ={}
}

internet_gateway = {
  igw-prod = {
    vpc_name              = "vpc-prod"
  }
}

nat = {
  nat-prod-pub-a = {
    connectivity_type     = "public"
    allocation_id         = "eip-prod-nat-prod-a"
    subnet_id             = "subnet-prod-pub-a"
  }
}

route_table = {
  rtbl-prod-pvt-subnets = {
    vpc_name               = "vpc-prod"
    route_table_name       = "rtbl-prod-pvt-subnets"
  }
  rtbl-prod-pub-subnets = {
    vpc_name               = "vpc-prod"
    route_table_name       = "rtbl-prod-pub-subnets"
  }
}

private_routes = {
  rtbl-prod-pvt-subnets={
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_name       = "nat-prod-pub-a"
  }
}

public_routes ={
  rtbl-prod-pub-subnets={
    destination_cidr_block = "0.0.0.0/0"
    igw_name = "igw-prod"
  }  
}

route_table_association_pvt = {
  association_1 = {
    subnet_name              = "subnet-prod-pvt-a"
    route_table_name         = "rtbl-prod-pvt-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-prod-pvt-b"
    route_table_name         = "rtbl-prod-pvt-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-prod-pvt-c"
    route_table_name         = "rtbl-prod-pvt-subnets"
  }  
}

route_table_association_pub = {
  association_1 = {
    subnet_name              = "subnet-prod-pub-a"
    route_table_name         = "rtbl-prod-pub-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-prod-pub-b"
    route_table_name         = "rtbl-prod-pub-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-prod-pub-c"
    route_table_name         = "rtbl-prod-pub-subnets"
  }    
}
### SG EKS ###

security_groups = {
  sg_eks_prod_genia = {
    vpc_name         = "vpc-prod"
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
  sg_rds_prod_genia = {
    vpc_name         = "vpc-prod"
    description_rule = "Security group Cluster EKS"
    cidr_blocks_in   = ["10.120.224.0/22", "10.110.0.0/24"]
    from_port_in     = 3306
    to_port_in       = 3306
    protocol_in      = "tcp"
    from_port_out    = 0
    to_port_out      = 0
    protocol_out     = "-1"
    cidr_blocks_out  = ["0.0.0.0/0"]
  }  
  sg_nlb_prod_genia = {
    vpc_name         = "vpc-prod"
    description_rule = "Security group SFTP EKS"
    cidr_blocks_in   = ["10.110.0.0/24", "10.120.224.0/22"]
    from_port_in     = 22
    to_port_in       = 22
    protocol_in      = "tcp"
    from_port_out    = 0
    to_port_out      = 0
    protocol_out     = "-1"
    cidr_blocks_out  = ["0.0.0.0/0"]
  }    
}

### EKS Cluster ###

eks = {
  eks-prod-genaia = {
    name                    = "eks-prod-genaia"
    role_arn                = "arn:aws:iam::105054799343:role/EKSGENAIAClusterRole"
    vpc_name                = "vpc-prod"
    cluster_security_group_id = "sg_cluster_eks"
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
    version-eks             = "1.28"
    subnet_name-a           ={
      subnet_name = "subnet-prod-pvt-a"
    }
    subnet_name-b           ={
      subnet_name = "subnet-prod-pvt-b"
    }
    subnet_name-c           ={
      subnet_name = "subnet-prod-pvt-c"
    }
    authentication_mode      = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
    
  }
}

eks-addon ={
    addon_1 = {
      addon_name            =  "vpc-cni"
      cluster_name          =  "eks-prod-genaia"
    }
    #addon_2 = {
    #  addon_name            =  "coredns"
    #  cluster_name           =  "eks-prod-genaia"      
    #}       
    addon_3 = {
      addon_name            =  "kube-proxy"
      cluster_name          =  "eks-prod-genaia"
    }  
    addon_4 = {
      addon_name            =  "eks-pod-identity-agent"
      cluster_name          =  "eks-prod-genaia"
    }                
}

eks-nodes = {
  m7i_2xlarge_prod = {
    cluster_name    = "eks-prod-genaia"
    #node_group_name = "eks-prod-genaia-nodes"
    node_role_arn   = "arn:aws:iam::105054799343:role/AmazonEKSNodeRole_prod"
    ami_type        = "AL2_x86_64" #Amazon Linux 2
    capacity_type   = "ON_DEMAND" 
    disk_size       = "20"
    instance_types  = ["m7i.2xlarge"] # 8 CPU / 32 RAM
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-prod-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-prod-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-prod-pvt-c"
      }
    }
    desired_size    = 2
    max_size        = 2
    min_size        = 2
    max_unavailable = 1
  }
}

subnet_group = {
  db_subnet_prod_pvt ={
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-prod-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-prod-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-prod-pvt-c"
      }
    }
  }
}

rds ={
  rdsprodgenaia = {
    db_name= "wordpress"
    db_subnet_group_name = "db_subnet_prod_pvt"
    allocated_storage = "40"
    max_allocated_storage = "200"
    engine = "MariaDB"
    engine_version = "10.11.6"
    instance_class = "db.t3.medium"
    multi_az = "false"
    username = "admin"
    password = "QGj!xjy9r#u7uDiw"
    parameter_group_name = ""
    vpc_security_group_ids = ""
    skip_final_snapshot = "true"
    backup_retention_period     = 7
    backup_window = "01:00-02:00"
    publicly_accessible = "false"
    vpc_security_group_ids = "sg_rds_prod_genia"
  }
}

backup-vault = {
  rds-prod-genaia={
    kms_key_arn = "arn:aws:kms:eu-south-2:105054799343:key/41aa3c56-7c43-40aa-a61c-36554f781d72"
  }
}

backup-plan =  {
  rds-genaia-prod-daily= {
    rule_name         = "Daily-7days-Retention"
    target_vault_name = "rds-prod-genaia"
    schedule          = "cron(0 1 * * ?)"
    delete_after = 7
  }
  rds-genaia-prod-week= {
    rule_name         = "Week-1mouth-Retention"
    target_vault_name = "rds-prod-genaia"
    schedule          = "cron(0 2 ? * 1)"
    delete_after = 30
  }  
}

backup-selection = {
  Daily-7days-Retention= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-prod-genaia"
    plan_id              = "rds-genaia-prod-daily"
    db_rds               = "rdsprodgenaia"
  }
  rds-genaia-prod-week= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-prod-genaia"
    plan_id              = "rds-genaia-prod-week"
    db_rds               = "rdsprodgenaia"
  }    
}