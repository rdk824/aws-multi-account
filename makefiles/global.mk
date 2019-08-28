global: plan_global
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.global

plan_global: init_global
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.global

init_global: init tf_global_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_global_remote_state:
	# Generate tf remote state
	$(SCRIPTS)/tf-remote-state.sh global > $(ROOT_DIR)terraform.tf

refresh_global: init_global
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.global

destroy_global: init_global
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.global



.PHONY: global destroy_global refresh_global plan_global init_global tf_global_remote_state
