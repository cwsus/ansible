#=====  ANSIBLE   =============================================================
#          NAME:  host_vars/${HOSTNAME}
#   DESCRIPTION:  Configuration file for specific target host within playbook
#==============================================================================
---
create_default_accounts: FALSE
apply_global_config: FALSE