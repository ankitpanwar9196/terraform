variable "RDS_CIDR" {}
variable "DB_INSTANCE_CLASS" {}
variable "RDS_ENGINE" {}
variable "ENGINE_VERSION" {}
variable "BACKUP_RETENTION_PERIOD" {}
variable "PUBLICLY_ACCESSIBLE" {}
variable "RDS_USERNAME" {}
variable "RDS_PASSWORD" {}
variable "RDS_PORT" {}
variable "RDS_ALLOCATED_STORAGE" {}
variable "project_name"{
    #default = "RDSSETUP"
}
variable "PEM_FILE" {}

####################EC2-instance ###################
variable "instance_type" {}
variable "web_CIDR" {}
variable "USER_DATA_FOR_WebAppserver" {}
variable "USER_DATA_FOR_Appserver" {}
