resource "aws_instance" "webserver" {

  ami = "${data.aws_ami.most_recent_ubuntu_xenial.id}"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.webserver.id}"
  user_data = "${file("${path.module}/install_nginx.sh")}"
  key_name = "${aws_key_pair.keys_to_the_castles.key_name}"
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags {

    Name = "private-webserver"
    managed-by-terraform = 1
  }
}