#!/bin/bash
for file in out/*/queue/*
do
    ./bin_cov < $file
done

for file in out/*/crashes/*
do
    ./bin_cov < $file
done
