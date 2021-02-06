#!/usr/bin/env bash

export ALL_PROXY=socks5://127.0.0.1:7891

rm -rf content/*
rm -rf static/ox-hugo
cd ox-hugo; make md; cd -

cd content
# 删除所有的日记，日记不导出
rm -rf post/diaries
# 删除draft
grep -lrn "draft = true" * | xargs rm -rf
cd -

git add .
git ci -m "update blog"
git push
