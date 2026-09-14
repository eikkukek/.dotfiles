#!/bin/bash

session_name=$1

out=$(awk 'NR==2' "/tmp/.${session_name}")

echo " $out"
