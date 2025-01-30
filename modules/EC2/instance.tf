
# resource "aws_instance" "servers" {
#   count                  = 2  
#   ami                    = count.index == 0 ? data.aws_ami.ubuntu.id : data.aws_ami.ubuntu.id
#   instance_type          = count.index == 0 ? "t2.medium" : var.instance_type
#   key_name               = var.key_name
#   vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
#   root_block_device {
#     volume_size = count.index == 0 ? 30 : null 
#   }

#   # user_data = <<-EOF
#   #             #!/bin/bash
#   #             ${
#   #               count.index == 0 ? 
#   #               "${file("${path.module}/scripts/voguepay.sh")}\n${file("${path.module}/scripts/jenkins_master.sh")}" :
#   #               file("${path.module}/scripts/jenkins_slave.sh")
#   #             }
#   # EOF

#   user_data = count.index == 0 ? file("${path.module}/scripts/custom_server_demo_project.sh") : null

#   tags = merge(var.common_tags, {
#     Name = format("%s-%s-%s-%s", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"],
#     count.index == 0 ? "main-server" : "jenkins-slave")
#   })
# }

resource "aws_instance" "servers" {
  #count                  = 2  
  ami                    =  data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  root_block_device {
    volume_size =  var.volume_size
  }


  user_data = file("${path.module}/scripts/sonar.sh") 

  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-%s", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"],
     "main-server")
  })
}
