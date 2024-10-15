resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "waf"
  description = "WAF to protect ALB from malicious IPs"
  scope       = "REGIONAL"  # For ALB, we use regional WAF
  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesAmazonIpReputationList"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-metrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  resource_arn = module.waf_alb.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}