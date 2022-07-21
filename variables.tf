variable "Subscription_id" {
    type = string
    description = "ID for your azure subscription"
}

variable "domain_name" {
    type = string
}

variable "resource_group_name"{
    type = string
}

variable "a_records" {
    type = list(object({
        name = string
        ttl = number
        value = list(string)
    }))
    description = "List of A records."
}

variable "mx_records" {
    type = list(object({
        name = string
        priority = number
        ttl = number
        value = string
    }))
    description = "List of MX Records."
}

variable "cname_records" {
    type = list(object({
        name = string
        ttl = number
        value = string
    }))
    description = "List of CNAME records."
}

variable "srv_records" {
    type = list(object({
        name = string
        preference = number
        weight = number
        port = number
        ttl = number
        value = string
    }))
    description = "List of SRV records"
}

variable "txt_records" {
    type = list(object({
        name = string
        ttl = number
        value = list(string)
    }))
    description = "List of TXT records"
}

variable "ns_records" {
    type  = list(object({
        name = string
        ttl  = number
        value = list(string)
    }))
    description = "List of NS records."
}

variable "ptr_records" {
    type  = list(object({
        name = string
        ttl = number
        value = string
    }))
    description = "List of PTR records."
}