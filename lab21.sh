#!/bin/bash

# RHCSA Labs lesson 21 script
# SvV
# version 0.1

grep -i enforcing /etc/sysconfig/selinux >/dev/null 2>&1 || echo no enforcing set in /etc/sysconfig/selinux
getenforce | grep -i enforcing >/dev/null 2>&1 || echo currently not in enforcing mode
history | tail -20 | grep restorecon >/dev/null 2>&1 || echo you have not run the restorecon command recently
