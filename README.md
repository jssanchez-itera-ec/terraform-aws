# Diagrama de Arquitectura
leer ./Arquitectura-Prod.drawio.png  
modificar ./Arquitectura-Prod.drawio

# genaia-eks
genaia-eks

Este Repositorio contiene los archivos de IaC (Infraestructure as Code) y Ansible, con los que fue desplegado el repositorio.

## Pre-Requisitos
1. Install Terraform
2. Modificar el archivo de variables segun necesidad  
      Ambiente Preprod: 'Terraform/Env/Preprod.tfvars'  
      Ambiente Prod: 'Terraform/Env/Prod.tfvars' 
3. Install helm

## Terraform 
Utilizamos la modularización para el despliegue de los recursos, los recursos que se crearan son los siguientes:  
| Recurso | Descripción |
|--------|-------------|
| VPC | 1 VPC para el Entorno |
| Private Subnet | 3 Subnets Privadas | 
| Public Subnet | 1 Subnet Publica| 
| Elastic_IP | 1 IP Elastica Publica para el NAT GATEWAY Publico |
| Internet_Gateway | 1 Internet Gateway para las subnets publicas |
| NAT_Gateway | 1 NAT Gateway Publico |
| Route_Table | 2 Route Tables Subnet Privadas y Publicas |
| Private_Routes | Rutas Privadas |
| Public_Routes  | Rutas Publicas |
| Route_Table_Association_Private | Asociacion de rutas al Route Table Privado |
| Route_Table_Association_Public | Asociacion de rutas al Route Table Publico |
| EKS_Cluster | 1 Cluster EKS |
| EKS_Addon | Los Complementos Principales para el funcionamiento del cluster y la comunicación de los servicios |
| EKS_Node_Group | Grupo de Nodos del Cluster EKS |
| RDS_subnet_group | Grupo de Subnets de RDS MariaDB |
| RDS | Base de datos MariaDB en RDS |
| Backup_Vault | Vault del Servicio de AWS |
| Backup_Plan | Plan del servicio de AWS |
| Backup_Selection | Seleccion de RDS para la creación del Backup |


1. Dirigirse a la ruta donde esta el arbol de trabajo de terraform  
 `cd Terraform`

2. Modificar el archivo 'backend.tf' y modificar la linea de path para elegir el nombre del tfstate(archivo control de cambios)  
 `path = "terraform-preprod.tfstate"`  
 'Preprod=terraform-preprod.tfstate'  
 'Prod=terraform-prod.tfstate'  
 NOTA: Este archivo no se puede dejar por variables, por tal razon es importante tener SUMAMENTE CUIDADO para no dañar el archivo.  

3. Inicializar los modulos
`terraform init`

4. Revisión y validación los cambios por aplicar aplicar  
`terraform plan --var-file="./Env/Preprod.tfvars"` o   
`terraform plan --var-file="./Env/Prod.tfvars"`

5. Aplicación y despliegue de cambios  
`terraform apply --var-file="./Env/Preprod.tfvars"` o  
`terraform apply --var-file="./Env/Prod.tfvars"`

### IMPORTANTE
Al ejecutar el terraform apply se genera automaticamente el archivo ***terraform.tfstate*** este archivo es el que contiene el control de cambios ejecutados, ***NO ELIMINAR***. en caso de que se pierda este archivo al hacer un terraform plan o un terraform apply, este no reconocera ningun recurso previamente creado; En pocas palabras creara recursos nuevos ante cualquier modificación.

## Storage Class EFS - AWS
1. Crear EFS en la VPC requerida
2. Modificar Security Group asociado al EFS y permitir el puerto TCP 2049  
3. Crear Role para EFS  
   Preprod:  ***AmazonEKS_GENAIAPREPROD_EFS_CSI_DriverRol***  
   Prod:  ***AmazonEKS_GENAIAPROD_EFS_CSI_DriverRol***  
4. Modificar Relacion de confianza del Role  
   Preprod: 'storageclass/iam/efs/trust-relation-preprod.json'  
   Prod:  'storageclass/iam/efs/trust-relation-prod.json'  
5. Asociar Policy ***AmazonEKS_EFS_CSI_Driver_Policy*** al Role previamente creado, si no existe crear la policy que se encuentra en la siguiente ruta:  
   'storageclass/iam/efs/AmazonEKS_EFS_CSI_Driver_Policy.json'
6. Desplegar Addon ***Mountpoint for Amazon EFS CSI Driver*** Cluster EKS y asociar Role ***AmazonEKS_GENAIAPROD_EFS_CSI_DriverRol*** o  ***AmazonEKS_GENAIAPREPROD_EFS_CSI_DriverRol***

En caso de tener alguna duda sobre el proceso o la arquitectura del storage class seguir las siguientes documentaciones  
- https://docs.aws.amazon.com/es_es/eks/latest/userguide/efs-csi.html
- https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/README.md#examples 

## Ingres Nginx
Para el servicio de ingress, es necesario realizar el despliegue de ingress Nginx antes de iniciar las actividades de Kubernetes,
1. Instalar Helm
2. Ejecutar el siguiente comando
   `helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.service.type=LoadBalancer --set controller.service.externalTrafficPolicy=Local --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-internal"="true"`

## Kubernetes
1. Aplicar los archivos yaml que realizan la instalación de wordpress
   Preprod: `kubectl apply -f ./kubernetes/Preprod/wordpress/`  
   Prod: `kubectl apply -f ./kubernetes/Prod/wordpress/`  
2. Instalar Certificado
   `kubectl apply -f ./kubernetes/cert/wordpress-cert-ingress.yaml`
3. Instalar SFTP
   `kubectl apply -f ./kubernetes/Preprod/sftp/`  
   `kubectl apply -f ./kubernetes/Prod/sftp/`  

## Modificar /etc/hosts Local
Para el caso de GENAIA se utilizo el mismo DNS, por tal razón es importante modificarse el etc/hosts y añadir el registro dependiendo del ambiente que se requiera usar

1. `kubectl get svc sftp-service -n wordpress`
2. `kubectl get ingress -n wordpress`



  

