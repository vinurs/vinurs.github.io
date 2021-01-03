#!/usr/bin/env bash

rm -rf content/*
cd ox-hugo; make md; cd -
git add .
git ci -m "update blog"
git push
