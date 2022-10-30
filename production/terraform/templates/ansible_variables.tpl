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

    forward_from: # FORWARD TO WAN
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "any", "dest_port" : "80"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "any", "dest_port" : "443"}
  

  - name: "lan"
    type: "private"
    ipv4: "${lan_network}"
    prefix: "24"

    forward_from: # FORWARD TO LAN
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "80"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "443"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "3306"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "4567"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "4568"}
      - { "src_network" : "lan", "src_addr" : "network", "src_port" : "any", "dest_addr" : "network", "dest_port" : "4444"}

  - name: "dmz"
    type: "public"
    ipv4: "${dmz_network}"
    prefix: "24"