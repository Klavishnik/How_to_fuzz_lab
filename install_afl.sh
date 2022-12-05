#!/bin/bash

cd ..
git clone https://github.com/AFLplusplus/AFLplusplus
cd AFLplusplus
make distrib
sudo make install

echo "DONE"
