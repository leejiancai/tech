#!/usr/bin/env bash

# 编译_book
gitbook build

# 切换到gh-pages分支
git checkout gh-pages

# 删除旧的book
ls |grep -v "_book" |grep -v "node_modules" |xargs git rm -r

# 添加新的book
cp -r _book/* .
git add *

# commit 
git commit -m "Publish gitbook in $(date)"

# git push
git push

# 返回到master分支
git checkout master

