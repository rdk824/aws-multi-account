organization: plan_organization
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.organization

plan_organization: init_organization
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.organization

init_organization: init tf_organization_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_organization_remote_state:
	# Generate tf rmote state
	$(SCRIPTS)/tf-remote-state.sh organization > $(ROOT_DIR)terraform.tf

refresh_organization: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.organization

destroy_organization: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.organization


.PHONY: organization destroy_organization refresh_organization plan_organization init_organization tf_organization_remote_state
