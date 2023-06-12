#!/usr/bin/env bash
#
# run.sh - Start a deployment via Terraform.
#

terraform init
exit_status="$?"

# Terminate deployment if we get any errors along the way.
if [ "$exit_status" -eq 0 ]; then
	terraform plan
	exit_status="$?"

	if [ "$exit_status" -eq 0 ]; then
		terraform apply
	else
		exit 1
	fi

else
	exit 1
fi

