#!/usr/bin/env bash
set -e
name="$2"
dir="/tmp/$name"

mkdir -p $dir
rclone mount "$name:" $dir
