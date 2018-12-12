let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
"""
import docopt
import streams
import strutils
import tables
import terminal
import re
import sequtils
import sets

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

if args["<input>"]:
  filename = $args["<input>"]

type
  Rule = tuple[
    pattern: seq[bool],
    outcome: bool
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  rules = newSeq[Rule]()

proc str_to_seq(s: string): seq[bool] =
  var
    sequ = newSeq[bool]()
  for ch in s:
    if ch == '#':
      sequ.add(true);
    else:
      sequ.add(false);
  result = sequ
      
if not isNil(file):
  while file.readLine(line):
    var matches: array[2, string]
    if match(line, re"^(.*) => (.)$", matches, 0):
      var entry: Rule
      entry.pattern = str_to_seq(matches[0])
      entry.outcome = str_to_seq(matches[1])[0]
      rules.add(entry)
  file.close()

for r in rules:
  echo $r
