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

type
  Entry = tuple[
    id: int,
    left: int,
    top: int,
    width: int,
    height: int,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[Entry]()
  fabric: array[5000, array[5000, int]]
  overlap = 0
  clean_id = -1
  clean_area = 0

if not isNil(file):
  while file.readLine(line):
    var matches: array[5, string]
    if match(line, re"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)$", matches, 0):
      var entry: Entry
      entry.id = parseInt(matches[0])
      entry.left = parseInt(matches[1])
      entry.top = parseInt(matches[2])
      entry.width = parseInt(matches[3])
      entry.height = parseInt(matches[4])
      data.add(entry)
  file.close()

for entry in data:
  for x in entry.left..<(entry.left + entry.width):
    for y in entry.top..<(entry.top + entry.height):
      if fabric[x][y] == 1:
        overlap += 1
      fabric[x][y] += 1

for entry in data:
  var
    clean = true

  for x in entry.left..<(entry.left + entry.width):
    for y in entry.top..<(entry.top + entry.height):
      if fabric[x][y] > 1:
        clean = false

  if clean:
     clean_id = entry.id
     clean_area = entry.width * entry.height

if args["--test"]:
  for y in 0..<dim:
    for x in 0..<dim:
      var c = "."
      if fabric[x][y] > 0:
        c = "#"
      stdout.write c
    stdout.write "\n"

echo $overlap
echo $clean_id & " area: " & $clean_area
