---
# vars file for ipsec
tunnel:
  serenity:
    left:
        ipv4: "${serenity_ipv4}"
        key:  "${serenity_left_key}"
        id:   "0x201"
    right:
        ipv4: "${my_ipv4}"
        key:  "${serenity_right_key}"
        id:   "0x202"

  sputnik:
    left:
        ipv4: "${sputnik_ipv4}"
        key:  "${sputnik_left_key}"
        id:   "0x402"
    right:
        ipv4: "${my_ipv4}"
        key:  "${sputnik_right_key}"
        id:   "0x401"

  bastion:
    left:
        ipv4: "${bastion_ipv4}"
        key:  "${bastion_left_key}"
        id:   "0x902"
    right:
        ipv4: "${my_ipv4}"
        key:  "${bastion_right_key}"
        id:   "0x901"

  subnets:
%{ for subnet in my_subnets ~}
    -"${subnet}" 
%{ endfor ~}
