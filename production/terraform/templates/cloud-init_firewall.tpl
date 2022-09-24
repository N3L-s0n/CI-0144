#cloud-config
network:
    version: 2
    ethernets:
        ens160:
            addresses: [${firewall_public_ipv4}]
            gateway4: ${firewall_gateway_ipv4}
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
        ens192:
            addresses: [${firewall_private_ipv4}]
