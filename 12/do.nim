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
  gen = 0

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
  result = "[" & $gen & "] " & stri
      
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

#[
echo $pots
for r in rules:
  echo $r
]#

echo seq_to_str(pots)

proc tick(): seq[bool] =
  var
    pots_new = newSeq[bool]()

  for i in (low(pots) - 4)..(high(pots) + 4):
    var
      match = true
      outcome = false

    for rule in rules:
      match = true

      for j in -2..2:
        var
          offset = i + j
          pot_val = false

        if offset >= low(pots) and offset <= high(pots):
          pot_val = pots[offset]

        if not pot_val == rule.pattern[j + 2]:
          match = false
          break

      if match:
        outcome = rule.outcome
        break

    if match:
      pots_new.add(outcome)
    else:
      pots_new.add(false)

  result = pots_new

echo seq_to_str(tick())
    
