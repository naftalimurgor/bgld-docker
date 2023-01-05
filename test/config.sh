#!/bin/bash
set -e

testAlias+=(
	[bgld:trusty]='bgld'
)

imageTests+=(
	[bgld]='
		rpcpassword
	'
)
