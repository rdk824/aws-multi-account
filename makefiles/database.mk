database: plan_database
	cd $(ROOT_DIR); \
	$(TF_APPLY) -target module.database

plan_database: init_database
	cd $(ROOT_DIR); \
	$(TF_PLAN) -target module.database

init_database: init tf_database_remote_state
	cd $(ROOT_DIR); $(TF_INIT); $(TF_GET);

tf_database_remote_state:
	# Generate tf remote state
	$(SCRIPTS)/tf-remote-state.sh database > $(ROOT_DIR)terraform.tf

refresh_database: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_REFRESH) -target module.database

destroy_database: | $(TF_PROVIDER)
	cd $(ROOT_DIR); \
	$(TF_DESTROY) -target module.database



.PHONY: database destroy_database refresh_database plan_database init_database tf_database_remote_state
