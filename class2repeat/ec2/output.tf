output ami  {
    description = "Pulls ami data"
  value       = "aws_instance.web.ami"
}
 
output public_ip {
     description = "Pulls instance public IP"
  value       = "aws_instance.web.public_ip"
}
 
 output id {
     description = "Pulls ami  ID"
  value       = "aws_instance.web.id"
}