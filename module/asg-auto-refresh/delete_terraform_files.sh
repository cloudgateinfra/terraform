############################
####### !!! WARNING !!! ####
####### FOR TESTING ONLY ###
############################

# usage chmod u+x delete_terraform_files.sh
# to run "./delete_terraform_files.sh"

rm -rf terraform.tfstate && rm -rf terraform.tfstate.backup && rm -rf .terraform.lock.hcl && rm -rf .terraform/
