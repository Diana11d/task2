resource "aws_route53_record" "videos" {
  zone_id = "Z02921573EV45TRTS347A"
  name    = "videos.dianadauletkerey.link"
  type    = "CNAME"
  ttl     = 300
  records = [
      aws_elb.bar.dns_name 
   ]
}