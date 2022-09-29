#!/bin/bash

set -e # abort if there is an issue with any build
packer build -only='kickstarts.*' .
packer build -only='almalinux.*' .
packer build -only='centos.*' .
