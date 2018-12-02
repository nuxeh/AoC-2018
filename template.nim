import streams
import strutils
import tables

var
  file = newFileStream("input.txt", fmRead)
  line = ""

if not isNil(file):
  while file.readLine(line):
    echo line
