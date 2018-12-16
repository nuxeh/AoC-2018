#!/bin/bash

awk -f do.awk input.txt
nim compile -d:release --run do.nim
