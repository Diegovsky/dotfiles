#!/usr/bin/env bash
set -e

dir="/tmp/$1"

mkdir -p $dir
rclone mount $1 $dir
