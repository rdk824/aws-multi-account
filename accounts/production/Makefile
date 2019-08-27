SHELL=/bin/bash

# Profile
AWS_PROFILE := production
ACCOUNT_NAME := prod

# Define paths variables
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

export


all: prod

# Load all resouces makefile
include $(ROOT_DIR)../../makefiles/*.mk

.PHONY: all
