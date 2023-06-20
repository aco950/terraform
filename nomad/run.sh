#!/usr/bin/env bash
#

terraform init
exit_status="$?"

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

