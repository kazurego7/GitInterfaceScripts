#!/bin/bash

rm -rf local
rm -rf remote

mkdir local
mkdir remote

cd remote
git init --bare --shared

cd ../local
git init