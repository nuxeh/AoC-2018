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
import deques

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
  pots = newSeq[bool]()
# pots = initDeque[bool]()

proc str_to_seq(s: string): seq[bool] =
  var
    sequ = newSeq[bool]()
  for ch in s:
    if ch == '#':
      sequ.add(true);
    else:
      sequ.add(false);
  result = sequ

proc seq_to_str(s: seq[bool]): string =
  var
    stri = ""
  for ch in s:
    if ch == true:
      stri = stri & '#';
    else:
      stri = stri & ' ';
  result = stri
      
if not isNil(file):
  while file.readLine(line):
    var
      matches: array[2, string]
      matches2: string
    if match(line, re"^(.*) => (.)$", matches, 0):
      var entry: Rule
      entry.pattern = str_to_seq(matches[0])
      entry.outcome = str_to_seq(matches[1])[0]
      rules.add(entry)
    if match(line, re"^initial state: (.*)$", matches, 0):
      var pots_seq = str_to_seq(matches[0])
      pots = pots_seq
#[
      for p in pots_seq:
        pots.addLast(p)
]#
  file.close()

echo $pots
for r in rules:
  echo $r

echo seq_to_str(pots)

for i, p in pots:
  for rule in rules:
    var
      match = true

    for j in -2..2:
      var
        offset = i + j
      if offset > low(pots) and offset < high(pots):
        if not pots[offset] == rule.pattern[j + 2]:
          match = false

    if match:
      pots[i] = rule.outcome

echo seq_to_str(pots)
    
