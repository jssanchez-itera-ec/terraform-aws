### Providers ###
aws_credentials = {
    aws_region    = "us-east-1"  
    profile       = "usarboleda"
    path = "terraform-preprod-ssanchez.tfstate"
}

### Networking ###

vpc = {
    vpc-preprod-ssanchez ={
        cidr_block = "10.120.220.0/22"
    }
}

private_subnets = {
  subnet-preprod-ssanchez-pvt-a = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block          = "10.120.220.0/24"
    availability_zone   = "us-east-1a"
    map_public_ip_on_launch = false
  }
  subnet-preprod-ssanchez-pvt-b = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block         = "10.120.221.0/24"
    availability_zone   = "us-east-1b"
    map_public_ip_on_launch = false
  }
  subnet-preprod-ssanchez-pvt-c = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block         = "10.120.222.0/24"
    availability_zone   = "us-east-1c"
    map_public_ip_on_launch = false
 }
}

public_subnets = {
  subnet-preprod-ssanchez-pub-a = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block          = "10.120.223.0/26"
    availability_zone   = "us-east-1a"
    map_public_ip_on_launch = true
  }
  subnet-preprod-ssanchez-pub-b = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block         = "10.120.223.64/26"
    availability_zone   = "us-east-1b"
    map_public_ip_on_launch = true
  }
  subnet-preprod-ssanchez-pub-c = {
    vpc_name            = "vpc-preprod-ssanchez"
    cidr_block         = "10.120.223.128/26"
    availability_zone   = "us-east-1c"
    map_public_ip_on_launch = true
  } 
}

eip = {
  eip-preprod-ssanchez-nat-prod-a ={}
}

internet_gateway = {
  igw-preprod-ssanchez = {
    vpc_name              = "vpc-preprod-ssanchez"
  }
}

nat = {
  nat-preprod-ssanchez-pvt-a = {
    connectivity_type     = "public"
    allocation_id         = "eip-preprod-ssanchez-nat-prod-a"
    subnet_id             = "subnet-preprod-ssanchez-pub-a"
  }
}

route_table = {
  rtbl-preprod-ssanchez-pvt-subnets = {
    vpc_name               = "vpc-preprod-ssanchez"
    route_table_name       = "rtbl-preprod-ssanchez-pvt-subnets"
  }
  rtbl-preprod-ssanchez-pub-subnets = {
    vpc_name               = "vpc-preprod-ssanchez"
    route_table_name       = "rtbl-preprod-ssanchez-pub-subnets"
  }
}

private_routes = {
  rtbl-preprod-ssanchez-pvt-subnets={
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_name       = "nat-preprod-ssanchez-pvt-a"
  }
}

public_routes ={
  rtbl-preprod-ssanchez-pub-subnets={
    destination_cidr_block = "0.0.0.0/0"
    igw_name = "igw-preprod-ssanchez"
  }  
}

route_table_association_pvt = {
  association_1 = {
    subnet_name              = "subnet-preprod-ssanchez-pvt-a"
    route_table_name         = "rtbl-preprod-ssanchez-pvt-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-preprod-ssanchez-pvt-b"
    route_table_name         = "rtbl-preprod-ssanchez-pvt-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-preprod-ssanchez-pvt-c"
    route_table_name         = "rtbl-preprod-ssanchez-pvt-subnets"
  }  
}

route_table_association_pub = {
  association_1 = {
    subnet_name              = "subnet-preprod-ssanchez-pub-a"
    route_table_name         = "rtbl-preprod-ssanchez-pub-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-preprod-ssanchez-pub-b"
    route_table_name         = "rtbl-preprod-ssanchez-pub-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-preprod-ssanchez-pub-c"
    route_table_name         = "rtbl-preprod-ssanchez-pub-subnets"
  }    
}
### SG EKS ###

security_groups = {
  sg_eks_preprod-ssanchez_genia = {
    vpc_name         = "vpc-preprod-ssanchez"
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
  sg_rds_preprod-ssanchez_genia = {
    vpc_name         = "vpc-preprod-ssanchez"
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
  eks-preprod-ssanchez = {
    name                    = "eks-preprod-ssanchez"
    role_arn                = "arn:aws:iam::644263771432:role/ssanchez-ClusterRoleEKS-Itera"
    vpc_name                = "vpc-preprod-ssanchez"
    cluster_security_group_id = "sg_cluster_eks"
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    version-eks             = "1.30"
    subnet_name-a           ={
      subnet_name = "subnet-preprod-ssanchez-pvt-a"
    }
    subnet_name-b           ={
      subnet_name = "subnet-preprod-ssanchez-pvt-b"
    }
    subnet_name-c           ={
      subnet_name = "subnet-preprod-ssanchez-pvt-c"
    }
    authentication_mode      = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
    
  }
}

eks-addon ={
    addon_1 = {
      addon_name            =  "vpc-cni"
      cluster_name          =  "eks-preprod-ssanchez"
    }
    #addon_2 = {
    #  addon_name            =  "coredns"
    #  cluster_name           =  "eks-preprod-ssanchez-genaia"      
    #}       
    addon_3 = {
      addon_name            =  "kube-proxy"
      cluster_name          =  "eks-preprod-ssanchez"
    }  
    addon_4 = {
      addon_name            =  "eks-pod-identity-agent"
      cluster_name          =  "eks-preprod-ssanchez"
    }                
}

eks-nodes = {
  m7i_2xlarge = {
    cluster_name    = "eks-preprod-ssanchez"
    #node_group_name = "eks-preprod-ssanchez-genaia-nodes"
    node_role_arn   = "arn:aws:iam::644263771432:role/ssanchez-NodeRoleEKS-Iterav2"
    ami_type        = "AL2_x86_64" #Amazon Linux 2
    capacity_type   = "ON_DEMAND" 
    disk_size       = "50"
    instance_types  = ["t2.medium"] # 4 CPU / 2 RAM
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-preprod-ssanchez-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-preprod-ssanchez-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-preprod-ssanchez-pvt-c"
      }
    }
    desired_size    = 3
    max_size        = 3
    min_size        = 3
    max_unavailable = 3
  }
}

subnet_group = {
  db_subnet_preprod-ssanchez_pvt ={
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-preprod-ssanchez-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-preprod-ssanchez-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-preprod-ssanchez-pvt-c"
      }
    }
  }
}

rds ={
  rdspreprod-ssanchezgenaia = {
    db_name= "wordpress"
    db_subnet_group_name = "db_subnet_preprod-ssanchez_pvt"
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
    vpc_security_group_ids = "sg_rds_preprod-ssanchez_genia"
  }
}

backup-vault = {
  rds-preprod-ssanchez-genaia={
    kms_key_arn = "arn:aws:kms:eu-south-2:105054799343:key/41aa3c56-7c43-40aa-a61c-36554f781d72"
  }
}

backup-plan =  {
  rds-genaia-preprod-ssanchez-daily= {
    rule_name         = "Daily-7days-Retention"
    target_vault_name = "rds-preprod-ssanchez-genaia"
    schedule          = "cron(0 1 * * ?)"
    delete_after = 7
  }
  rds-genaia-preprod-ssanchez-week= {
    rule_name         = "Week-1mouth-Retention"
    target_vault_name = "rds-preprod-ssanchez-genaia"
    schedule          = "cron(0 2 ? * 1)"
    delete_after = 30
  }  
}

backup-selection = {
  Daily-7days-Retention= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-preprod-ssanchez-genaia"
    plan_id              = "rds-genaia-preprod-ssanchez-daily"
    db_rds               = "rdspreprod-ssanchezgenaia"
  }
  rds-genaia-preprod-ssanchez-week= {
    iam_role_arn         = "arn:aws:iam::105054799343:role/BackupServiceRoleToGenia"
    name                 = "rds-preprod-ssanchez-genaia"
    plan_id              = "rds-genaia-preprod-ssanchez-week"
    db_rds               = "rdspreprod-ssanchezgenaia"
  }    
}