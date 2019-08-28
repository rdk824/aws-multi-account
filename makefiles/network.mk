network: plan_network
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.network

plan_network: init_network
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.network

init_network: init tf_network_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_network_remote_state:
	# Generate tf rmote state
	$(SCRIPTS)/tf-remote-state.sh network > $(ROOT_DIR)terraform.tf

refresh_network: init_network
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.network

destroy_network: init_network
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.network

# get_network_provider: | $(TF_PROVIDER)
# 	@cp $(TF_PROVIDER) $(ROOT_DIR)provider.tf


.PHONY: network destroy_network refresh_network plan_network init_network tf_network_remote_state
