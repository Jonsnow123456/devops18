resource "aws_launch_template" "web_server_as" {
    name_prefix = "myproject"
    image_id           = "ami-09e6f87a47903347c"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t2.micro"
    key_name = "project"
     tag_specifications {
      resource_type = "instance"
    tags = {
        Name = "DevOps"
    }
    }
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0b8f074043eebed8a", "subnet-08084be035ffd6e5b"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1a", "us-east-1b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

