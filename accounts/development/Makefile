SHELL=/bin/bash

# Profile
AWS_PROFILE := development
ACCOUNT_NAME := dev

# Define paths variables
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

export


all: dev

# Load all resouces makefile
include $(ROOT_DIR)../../makefiles/*.mk

.PHONY: all
