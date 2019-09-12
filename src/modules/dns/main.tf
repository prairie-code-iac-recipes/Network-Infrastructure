resource "aws_route53_zone" "default" {
  count = "${length(var.domains)}"

  name = "${var.domains[count.index]}"

  tags = {
    Description = "${var.description_tag}"
    Group       = "${var.group_tag}"
  }
}
