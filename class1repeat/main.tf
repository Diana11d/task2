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