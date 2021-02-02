#!/usr/bin/env bash

export ALL_PROXY=socks5://127.0.0.1:7891

rm -rf content/*
cd ox-hugo; make md; cd -
# 删除draft
grep -lrn "draft = true" * | xargs rm -rf

git add .
git ci -m "update blog"
git push
