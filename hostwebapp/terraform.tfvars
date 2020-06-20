#variables value that point to variable.tf file
project_name                          = "RDS-SETUP"
RDS_CIDR                              = "0.0.0.0/0"
DB_INSTANCE_CLASS                     = "db.t2.micro"
RDS_ENGINE                            = "mysql"
ENGINE_VERSION                        = "5.7.17"
BACKUP_RETENTION_PERIOD               = "7"
PUBLICLY_ACCESSIBLE                   = "true"
RDS_USERNAME                          = "test"
RDS_PASSWORD                          = "test123#$"
RDS_ALLOCATED_STORAGE                 = "20"
project_name = "RDS-SETUP"
RDS_PORT                              = 3306
#############
instance_type = "t2.micro"
PEM_FILE = "ankit"
web_CIDR = "0.0.0.0/0"
USER_DATA_FOR_WebAppserver = "./code/web.sh"
USER_DATA_FOR_Appserver = "./code/app.sh"

#########################