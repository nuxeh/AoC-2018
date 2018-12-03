let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test data
"""
import docopt
import streams
import strutils
import tables
import terminal
import re

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

var
  file = newFileStream(filename, fmRead)
  line = ""
  fabric: array[2000, array[2000, bool]]
  overlap = 0

if not isNil(file):
  while file.readLine(line):
    var matches: array[5, string]
    if match(line, re"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)$", matches, 0):
      for s in matches:
        echo s
    var
      left = parseInt(matches[1]) + 1
      top = parseInt(matches[2]) + 1
      width = parseInt(matches[3])
      height = parseInt(matches[4])

    for x in left..(left+width):
      for y in top..(top+height):
        if fabric[x][y]:
          overlap++
        fabric[x][y] = true

  file.close()

  echo $overlap
