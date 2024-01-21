resource "aws_iam_user" "devops-diana" {
  name = "devops-diana"
  tags = {
    class = "terraform"
  }
  }

 resource "aws_iam_user" "devops-diana2" {
  name = "devops-diana2"
    tags = {
    class = "terraform"
  }
 } 

resource "aws_iam_group" "dianasteam" {
  name = "dianasteam"
  }

resource "aws_iam_group_membership" "dianasteam_team" {
  name = "dianasteam-group-membership"
  users = [
   aws_iam_user.devops-diana2.name
  ]

group = aws_iam_group.dianasteam.name
}

resource "aws_iam_user" "multiuser" {
  name = each.key 
  for_each = toset ([
    "bob",
    "sam",
    "nina",
  ])
 }
  
