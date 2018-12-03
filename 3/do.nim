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
  dim = 2000

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
  dim = 40
else:
  filename = "input.txt"

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[string]()
  fabric: array[5000, array[5000, int]]
  overlap = 0
  clean_id = -1
  clean_area = 0

if not isNil(file):
  while file.readLine(line):
    data.add(line)
  file.close()

for line in data:
  var matches: array[5, string]
  if match(line, re"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)$", matches, 0):
    var
      left = parseInt(matches[1])
      top = parseInt(matches[2])
      width = parseInt(matches[3])
      height = parseInt(matches[4])
      x = left
      y = top
      clean = true

    while x < left + width:
      y = top
      while y < top + height:
        if fabric[x][y] > 0:
          clean = false
        if fabric[x][y] == 1:
          overlap += 1
        fabric[x][y] += 1
        y += 1
      x += 1

    if clean:
       clean_id = parseInt(matches[0])
       clean_area = width * height

#    for x in range[left..(left+width)]:
#      for y in range[top..(top+height)]:
#        if fabric[x][y]:
#          overlap++
#        fabric[x][y] = true

# TODO: ranges/for loops?!

var
  x = 0
  y = 0

if args["--test"]:
  while y < dim:
    x = 0
    while x < dim:
      var c = "."
      if fabric[x][y] > 0:
        c = "#"
      stdout.write c
      x += 1
    stdout.write "\n"
    y += 1

echo $overlap
echo $clean_id & " area: " & $clean_area
