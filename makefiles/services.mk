services: plan_services
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.services

plan_services: init_services
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.services

init_services: init tf_services_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_services_remote_state:
	# Generate tf remote state
	$(SCRIPTS)/tf-remote-state.sh services > $(ROOT_DIR)terraform.tf

refresh_services: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.services

destroy_services: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.services



.PHONY: services destroy_services refresh_services plan_services init_services tf_services_remote_state
