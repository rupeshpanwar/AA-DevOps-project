resource "aws_instance" "PublicEC2" {
  count = length(data.terraform_remote_state.network-configuration.outputs.public_subnet_ids)
  ami =   var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_public_security_group.id]
  #subnet_id = aws_subnet.public_subnets[count.index].id
  subnet_id = data.terraform_remote_state.network-configuration.outputs.public_subnet_ids[count.index]
  key_name = "connective"
  tags = {
    Name = format("PublicEC2-%d", count.index+1)
  }
  user_data = <<-EOF
                sudo su
                yum update -y
                amazon-linux-extras enable epel
                yum install python3 -y
                set python /usr/bin/python3
                #echo “ec2-user ALL=(ALL) NOPASSWD: ALL” >> /etc/sudoers
                sudo su
                yum install ansible-y
                sudo amazon-linux-extras install ansible2 -y
                sudo yum install git-all -y
                EOF
  depends_on = ["aws_security_group.ec2_public_security_group"]
}
