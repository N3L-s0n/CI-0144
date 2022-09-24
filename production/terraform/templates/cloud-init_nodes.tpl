#cloud-config
network:
    version: 2
    ethernets:
        ens160:
            addresses: [${node_private_ipv4}]
            gateway4: ${gateway_ipv4}
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
