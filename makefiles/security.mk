security: plan_security
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.security

plan_security: init_security
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.security

init_security: init tf_security_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_security_remote_state:
	# Generate tf remote state
	$(SCRIPTS)/tf-remote-state.sh security > $(ROOT_DIR)terraform.tf

refresh_security: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.security

destroy_security: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.security



.PHONY: security destroy_security refresh_security plan_security init_security tf_security_remote_state
