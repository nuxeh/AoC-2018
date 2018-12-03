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

if not isNil(file):
  while file.readLine(line):
    var tokens = splitWhitespace(line)
    for t in tokens:
      echo $t
  file.close()

