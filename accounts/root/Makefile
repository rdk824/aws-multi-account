SHELL=/bin/bash

# Profile
AWS_PROFILE := root
ACCOUNT_NAME := root

# Define paths variables
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

export


all: root

# Load all resouces makefile
include $(ROOT_DIR)../../makefiles/*.mk

.PHONY: all
