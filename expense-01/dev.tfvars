 env                  = "dev"
 cidr_block_vpc           = 10.10.0.0/16
 enable_dns_hostnames = "true"
 enable_dns_support   = "true"
 region               = {
    default = ["us-east-1a", "us-east-1b" ]
                        }
 tags = {
        type = map
        default ={
        company =  xyz
        bu_unit = finance
        project_name = expense
                   }
        }
subnet_configs = {
  type = list(object(
      default (
      {subnet_name="subnet_public1-01" subnet_range="10.10.1.0/24"  az_name="us-east-1a"} ,
      {subnet_name="subnet_public1-02" subnet_range= "10.10.2.0/24"  az_name= "us-east-1b"},
      {subnet_name="subnet_web-01" subnet_range="10.10.3.0/24"  az_name="us-east-1a"},
      {subnet_name="subnet_web-02" subnet_range="10.10.4.0/24"  az_name="us-east-1b"},
      {subnet_name="subnet_app-01" subnet_range="10.10.5.0/24"  az_name="us-east-1a"},
      {subnet_name="subnet_app-02" subnet_range="10.10.6.0/24"  az_name="us-east-1b"},
      {subnet_name="subnet_db-01"  subnet_range="10.10.70/24"  az_name="us-east-1a"},
      {subnet_name="subnet_db-02"  subnet_range="10.10.7.0/24"  az_name="us-east-1b"})
 ))}
 public_subnet_configs = {
   type = list(object(
     default (
       {subnet_name="subnet_public1-01" subnet_range="10.10.1.0/24"  az_name="us-east-1a"} ,
       {subnet_name="subnet_public1-02" subnet_range= "10.10.2.0/24"  az_name= "us-east-1b"},
       )
   ))}
 web_subnet_configs = {
   type = list(object(
     default (
       {subnet_name="subnet_web-01" subnet_range="10.10.3.0/24"  az_name="us-east-1a"},
       {subnet_name="subnet_web-02" subnet_range="10.10.4.0/24"  az_name="us-east-1b"},
      )
   ))}
 app_subnet_configs = {
   type = list(object(
     default (
            {subnet_name="subnet_app-01" subnet_range="10.10.5.0/24"  az_name="us-east-1a"},
       {subnet_name="subnet_app-02" subnet_range="10.10.6.0/24"  az_name="us-east-1b"},
      )
   ))}
 db_subnet_configs = {
   type = list(object(
     default (
       {subnet_name="subnet_db-01"  subnet_range="10.10.70/24"  az_name="us-east-1a"},
       {subnet_name="subnet_db-02"  subnet_range="10.10.7.0/24"  az_name="us-east-1b"})
   ))}
 instance_type = "t3.micro"
 ami_id =""
 key_name =""
 security_group_ids =""
 max_count_mode_1 =2
 max_count_mode_2 =2