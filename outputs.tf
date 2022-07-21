output "Public_DNS_Zone" {
    value = try(azure_public_dns_zone.public_DNS_zone.name, "")
    description = "Name of Public Zone that has been deployed."
}