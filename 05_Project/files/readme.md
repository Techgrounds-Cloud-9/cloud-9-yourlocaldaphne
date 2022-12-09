# Project IaC
### Bicep

First sprint 3 weeks, second sprint 2 weeks.\
Max. €50.\
Requirements for v1.0:
- All VM disks must be encrypted.
- The web server must be backed up daily. The backups must be kept for 7 days.
- The web server must be installed in an automated manner.
- The admin/management server must be reachable with a public IP.
- The admin/management server should only be reachable from trusted locations (office/admin's home)
- The following IP ranges are used: 10.10.10.0/24 & 10.20.20.0/24
- All subnets must be protected by a subnet level firewall (NSG?).
- SSH or RDP connections to the web server may only be established from the admin server.
- Propose or implement improvements in the architecture are okay if it can be done within the deadline.

#
### Understanding document
- 2 servers web server and admin/management server, so 2 VMs(1 window, 1 linux) in 2 availability zones (same region).
- They are residing on 2 virtual networks and in their respective subnets. 
- Both the subnets have their own set of NSG rules . 
- The 2 Vnets are connected.
- Both subnets must be protected by NSG on the subnet level. 
- The web server should be accessible with a public ip for the public and via admin/management server. Http ports open. 
- It will automatically install the apache server.
- The admin server can access the web server using the SSH/RDP and has a public ip address to be accessed by a set of users. 
- A set of ip addresses from which you need to provide access to admin server, ranges: 10.10.10.0/24 & 10.20.20.0/24. 
- Public static, private dynamic.
- The web server should be backed up daily and the backup should be available for 7 days.
- The storage account has a post deployment script.(bootstrap script)
- The AAD integrated with and users need to be added. 

#
### Resources needed
- Resource Group
- Windows Virtual Machines for the admin server
- Linux Virtual Machines for the web server
- Virtual Network Peering
- Virtual Network for admin server with 1 subnet
- Virtual Network web server 1 subnet
- Network Security Group
- Disk Encryption Secret
- Public IP addresses
- Storage account  
- Container
- Blob Service
- Deployment Scripts
- Azure Key Vault
- Azure Active Directory
