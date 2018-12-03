import streams
import strutils
import tables
import terminal

var
  file = newFileStream("input.txt", fmRead)
  line = ""

if not isNil(file):
  while file.readLine(line):
    echo $line
  file.close()
