#!/bin/bash
wget https://cdn.patricktriest.com/data/books.zip
unzip books.zip
mkdir -p ../books
mv books/*.txt ../books 
rm -r -f books
