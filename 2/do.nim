import streams
import strutils
import tables

var
  file = newFileStream("input.txt", fmRead)
  line = ""

if not isNil(file):
  while file.readLine(line):
    for c in line.split(""):
        echo c
