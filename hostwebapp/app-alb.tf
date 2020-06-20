resource "aws_lb" "appserver" {
  name               = "appserver-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.applb_sg.id}"]
  subnets            = ["${aws_subnet.privatesubnet1.id}", "${aws_subnet.privatesubnet2.id}"]
#deletion of the load balancer will be disabled via the Terraform Api,its an good approach to set it true in protection but now i used it as #learning purpuse so i set it false
  enable_deletion_protection = false

  tags = {
    Environment = "backenedapp"
  }
}
######## Now add listener to these alb ,as alb support host based and path based Routing###
resource "aws_lb_listener" "appserver" {
    load_balancer_arn = "${aws_lb.appserver.arn}"
    port              = "80"
    protocol          = "HTTP"
  # if u want to used protocol https insted of http you can do two steps(ssl policy & certificate Arn)
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
   default_action {
       target_group_arn = "${aws_lb_target_group.appserver.arn}"
       type             = "forward"
  }}
#create listener rules
# suppose in Production i have some rules instead of attaching them all to listener type, i create another listner rules

  
# now i create a target group 

resource "aws_lb_target_group" "appserver" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  
  #lifecycle   

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 4
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}


#create launch configuration that used for ASG
resource "aws_launch_configuration" "appsetup" {
  name_prefix   = "terraform-lc-appdemo-"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  user_data = "${file("${var.USER_DATA_FOR_Appserver}")}"
  security_groups = ["${aws_security_group.appserverssg.id}"]
  key_name = "${var.PEM_FILE}"
  root_block_device
  {
    volume_type = "gp2"
    volume_size = "30"

  }

  lifecycle {
    create_before_destroy = true
  }
}

#create ASG that tie it all together 
resource "aws_autoscaling_group" "APPASG" {
  name                 = "terraform-appasg-demo"
  launch_configuration = "${aws_launch_configuration.appsetup.name}"
  min_size             = 1
  max_size             = 2
  health_check_type    = "ELB"
  desired_capacity     = 2
  #force_delete = Allows deleting the autoscaling group without waiting for all instances 
  #in the pool to terminate. You can force an autoscaling group
  # to delete even if it's in the process of scaling a resource.
  # Normally, Terraform drains all the instances before deleting the group.
   #This bypasses that behavior and potentially leaves resources dangling.
  force_delete         = true
  vpc_zone_identifier  = ["${aws_subnet.privatesubnet1.id}", "${aws_subnet.privatesubnet2.id}"]
  #depends_on = ["aws_alb.appserver.arn"]

  lifecycle {
    create_before_destroy = true
  }
}
output "Application Load Balancer Endpoint" {
    value = "${aws_lb.appserver.dns_name}"
}
