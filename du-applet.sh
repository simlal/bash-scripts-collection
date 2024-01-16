#!/usr/bin/bash

# Prints total disk usage
# Used in custom applet ui
df -h --total | grep total | awk '{print $3, "/", $2, "("$5")"}'
