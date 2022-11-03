--- # vars file for ipsec tunnel:
tunnel:

%{~ for datacenter in apollo_tunnel ~}
    ${ datacenter.name }:
        mine:
        %{~ for key, value in datacenter.mine ~}
            %{~ if key != "network" ~}
            ${ key }: "${ value }"
            %{~ else ~} 
            %{~ if length(value) != 0 ~}
            ${ key }:
            %{~ for item in value ~}
                - "${ item }"
            %{~ endfor}
            %{~ endif ~}
            %{~ endif ~}
        %{~ endfor ~}
        theirs:
        %{~ for key, value in datacenter.theirs ~}
            %{~ if key != "network" ~}
            ${ key }: "${ value }"
            %{~ else ~} 
            %{~ if length(value) != 0 ~}
            ${ key }:
            %{~ for item in value ~}
                - "${ item }"
            %{~ endfor}
            %{~ endif ~}
            %{~ endif ~}
        %{~ endfor ~}
%{~ endfor ~}

networks:
  - name: "wan"
    type: "public"
    ipv4: "${wan_network}"
    prefix: "24"

  - name: "lan"
    type: "private"
    router: "${firewall_private_ipv4}"
    ipv4: "${lan_network}"
    prefix: "24"
    dhcp:
      router: "${firewall_private_ipv4}"
      range_start: "${dhcp_range_start}"
      range_end: "${dhcp_range_end}"

  - name: "dmz"
    type: "private"
    ipv4: "${dmz_network}"
    prefix: "24"

dns_servers: []
dhcp_md5_key: "${dhcp_md5_key}"