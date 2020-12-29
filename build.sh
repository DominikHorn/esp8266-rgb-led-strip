#!/bin/bash

cd "$(dirname "$0")"

make -C . clean
make -C . all
make -C . erase_flash
make -C . flash
