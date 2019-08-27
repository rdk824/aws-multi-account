# Profile
ROOT_AWS_PROFILE := root


SCRIPTS := $(ROOT_DIR)../../scripts
TF_VARS=$(ROOT_DIR)variables.tf

# AWS Infrastructure
AWS_ORGANIZATION_DIR := $(ROOT_DIR)organization
AWS_BACKUP_DIR := $(ROOT_DIR)backup
AWS_DISTRIBUTION_DIR := $(ROOT_DIR)distribution
AWS_DATABASE_DIR := $(ROOT_DIR)database
AWS_GLOBAL_DIR := $(ROOT_DIR)global
AWS_LOGGING_DIR := $(ROOT_DIR)logging
AWS_MONITORING_DIR := $(ROOT_DIR)monitoring
AWS_NETWORKING_DIR := $(ROOT_DIR)network
AWS_SECURITY_DIR := $(ROOT_DIR)security
AWS_SERVICES_DIR := $(ROOT_DIR)services


# Terraform files
TF_PROVIDER := $(ROOT_DIR)provider.tf
TF_DESTROY_PLAN := $(ROOT_DIR)destroy.tfplan
TF_APPLY_PLAN := $(ROOT_DIR)destroy.tfplan
TF_STATE := $(ROOT_DIR)terraform.tfstate
TF_CLI_CONFIGURATION := $(HOME)/.terraformrc
TF_PLUGIN_CACHE_DIR := $(HOME)/.terraform.d/plugins

# Terraform commands
TF_GET := terraform get -update
TF_SHOW := terraform show
TF_GRAPH := terraform graph -draw-cycles -verbose
TF_INIT := terraform init
TF_PLAN := terraform plan
TF_APPLY := terraform apply
TF_REFRESH := terraform refresh
TF_DESTROY := terraform destroy -force

export


init: setup_project
	@if [ ! -d $(TF_PLUGIN_CACHE_DIR) ]; then \
		mkdir -p $(TF_PLUGIN_CACHE_DIR); \
	fi
	@echo 'plugin_cache_dir = "$(TF_PLUGIN_CACHE_DIR)"' > $(TF_CLI_CONFIGURATION)

setup_project: check_aws_profile
	$(SCRIPTS)/set_provider.sh $(ROOT_DIR)

check_aws_profile: ## validate AWS profile
	@if ! aws --profile ${AWS_PROFILE} sts get-caller-identity --output text --query 'Account' > /dev/null 2>&1 ; then \
	  echo "ERROR: AWS profile \"${AWS_PROFILE}\" is not setup!"; \
	  exit 1 ; \
	fi
