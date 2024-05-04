locals {
  domain_name = "${var.project}.${var.zone_name}"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.zone.zone_id

  subject_alternative_names = [
    "*.${local.domain_name}",
  ]

  wait_for_validation = true

  tags = merge(
    var.tags,
    { Name = "${local.global_prefix}-eks" }
  )
}
