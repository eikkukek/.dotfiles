#!/bin/bash

session_name=$1

out=$(awk 'NR==1' "/tmp/.${session_name}")

echo "$out "
