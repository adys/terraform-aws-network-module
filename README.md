Terraform module - aws network
==============================

- The module creates one vpc + common network components (IGW, EIPs, NAT GWs, Subnets and Route Tables) with high availability in mind.

Module Arguments
----------------

- `environment_name` - the module is supposed to separate environments on the VPC level. The argument is used to set Name tags which helps to identify what environment the resource belongs to.
- `vpc_subnet` - IPv4 CIDR subnet which is assigned to the VPC.
- `public_subnets` - list of IPv4 CIDR subnets which are assigned to the public subnets.
- `private_subnets` - list of IPv4 CIDR subnets which are assigned to the private subnets.
- `availability_zones` - list of AZs where the network components are created.

Example
-------

- An example of how to use this module can be found in `main.tf` and `terraform.tfvars` files.
- The subnets were calculated based on the following:

- Public subnet – external subnets that have public IP addresses associated to servers and can be accessible from the Internet. They are analogous to traditional DMZ Networks.
- Private subnet – internal subnets that have only private IP addresses associated to server and are not accessible from the internet. They are able to access the Internet via NAT.
- Protected subnet – internal subnets that have only private IP addresses associated to the resources and are not accessible from the internet. They are NOT able to access the Internet.

```
10.10.0.0/16:
    10.10.0.0/18 — AZ A
        10.10.0.0/20 — Private
        10.10.16.0/20 - Public
        10.10.32.0/20 - Protected
        10.10.48.0/20 - Spare

    10.10.64.0/18 — AZ b
        10.10.64.0/20 — Private
        10.10.80.0/20 — Public
        10.10.96.0/20 - Protected
        10.10.112.0/20 - Spare

    10.10.128.0/18 — AZ c
        10.10.128.0/20 — Private
        10.10.144.0/20 — Public
        10.10.160.0/20 - Protected
        10.10.178.0/20 - Spare

    10.10.192.0/18 — Spare
```
