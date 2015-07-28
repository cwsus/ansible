#=====  ANSIBLE   =============================================================
#          NAME:  host_vars/${HOSTNAME}
#   DESCRIPTION:  Configuration file for specific target host within playbook
#==============================================================================
---
create_default_accounts: TRUE
apply_global_config: TRUE
apply_domains: TRUE
apply_cos: TRUE