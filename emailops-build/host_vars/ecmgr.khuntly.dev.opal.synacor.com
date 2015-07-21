#=====  ANSIBLE   =============================================================
#          NAME:  host_vars/${HOSTNAME}
#   DESCRIPTION:  Configuration file for specific target host within playbook
#==============================================================================
---
## These variables will be used to generate the unattended installation options file
## Change to suit environment
build_type: MessageSystems Cluster Manager
server_type: ecmgr

inbound_hosts:
  - name: "mx01.{{ client_name }}.{{ datacenter }}.synacor.com"
    address: <ipaddr>
  - name: "mx02.{{ client_name }}.{{ datacenter }}.synacor.com"
    address: <ipaddr>

outbound_hosts:
  - name: "smtp01.{{ client_name }}.{{ datacenter }}.synacor.com"
    address: <ipaddr>
  - name: "smtp02.{{ client_name }}.{{ datacenter }}.synacor.com"
    address: <ipaddr>
