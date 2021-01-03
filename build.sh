#!/usr/bin/env bash

rm -rf content/*
cd ox-hugo; make md; cd -
