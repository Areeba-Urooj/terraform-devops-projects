output "aws_instance_ip" {
  description = "The IP of this instance is: "
  value = aws_instance.nginx-server-stolkholme.public_ip
}
output "aws_instance_url" {
  description = "The URL to access the NGINX server"
  value = "http://${aws_instance.nginx-server-stolkholme.public_ip}"
}