variable "aws-instance-type" {
  description = "What type of instance you want to create?"
  type = string
  validation {
    condition = var.aws-instance-type=="t2.micro" || var.aws-instance-type=="t3.micro"
    error_message = "Only t2 and t3 micro allowed"
  }
}
variable "ec2-config" {
  type = object({
    v-size = number
    v-type = string
  })
  default = {
    v-size = 20
    v-type = "gp2"
  }
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "value"
  }
}
