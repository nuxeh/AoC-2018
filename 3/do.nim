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

if not isNil(file):
  while file.readLine(line):
    var
      tokens = splitWhitespace(line)
      top = tokens[2]
      left = 0
      width = 0
      height = 0
    for t in tokens:
      echo $t
  file.close()

