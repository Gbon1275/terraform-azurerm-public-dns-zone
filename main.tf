#--------------------------------------------------------------------------------------------------------------------
# AZURE PUBLIC DNS MODULE
#--------------------------------------------------------------------------------------------------------------------

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "DNS_ResourceGroup" {
  name = var.resource_group_name
}

locals {
    a_records      = var.a_records
    mx_records     = var.mx_records
    srv_records    = var.srv_records
    cname_records  = var.cname_records
    txt_records    = var.txt_records
    ptr_records    = var.ptr_records
    ns_records     = var.ns_records
}

#--------------------------------------------------------------------------------------------------------------------
# Deploying the azure public dns zone
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_zone" "public_DNS_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

#--------------------------------------------------------------------------------------------------------------------
# Public DNS A Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_a_record" "a_records_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.a_records : rs.name => rs}

  resource_group_name = var.resource_group_name
  zone_name           = var.domain_name
  
  name = each.value.name
  ttl = each.value.ttl
  records = each.value.value
}

#--------------------------------------------------------------------------------------------------------------------
# Public DNS CNAME Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "cname_records_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.cname_records : rs.name => rs}

  resource_group_name = var.resource_group_name
  zone_name           = var.domain_name

  name   = each.value.name
  ttl    = each.value.ttl
  record = each.value.value
}

#--------------------------------------------------------------------------------------------------------------------
# Public DNS MX Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_mx_record" "mx_record_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.mx_records : rs.name => rs}

  resource_group_name = var.resource_group_name
  zone_name           = var.domain_name

  name = each.value.name
  ttl  = each.value.ttl

  record {
      preference = each.value.priority
      exchange = each.value.value
  }
  
}


#--------------------------------------------------------------------------------------------------------------------
# Public DNS SRV Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_srv_record" "srv_records_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.srv_records : rs.name => rs}

  resource_group_name = var.resource_group_name 
  zone_name           = var.domain_name

  name = each.value.name
  ttl  = each.value.ttl

  record {
      priority = each.value.preference
      weight = each.value.weight
      port = each.value.port
      target = each.value.value
  }
}


#--------------------------------------------------------------------------------------------------------------------
# Public DNS TXT Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_txt_record" "txt_records_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.txt_records : rs.name => rs}

  resource_group_name = var.resource_group_name 
  zone_name           = var.domain_name

  name = each.value.name
  ttl  = each.value.ttl

  dynamic "record"{
    for_each = each.value.value
    content {
      value = record.value
    }
  }
}

#--------------------------------------------------------------------------------------------------------------------
# Public NS Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_ns_record" "ns_records" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.ns_records : rs.name => rs}
  
  zone_name           = var.domain_name  
  resource_group_name = var.resource_group_name 
  
  name                = each.value.name
  ttl                 = each.value.ttl

  records = each.value.value
}

#--------------------------------------------------------------------------------------------------------------------
# Public DNS PTR Records
#--------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_ptr_record" "ptr_records_public" {
  depends_on = [
    azurerm_dns_zone.public_DNS_zone
  ]
  for_each = { for rs in local.ptr_records : rs.name => rs }

  zone_name           = var.domain_name  
  resource_group_name = var.resource_group_name 

  name                = each.value.name
  ttl                 = each.value.ttl
  records             = each.value.value
}

output "Private_DNS_Zone" {
  value = var.domain_name
}