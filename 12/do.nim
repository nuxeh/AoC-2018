let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
  --part2         Use parameters for part 2
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

proc tick(pots_in: seq[bool]): seq[bool] =
  var
    pots_new = newSeq[bool]()

  for i in (low(pots_in) - 4)..(high(pots_in) + 4):
    var
      match = true
      outcome = false

    for rule in rules:
      match = true

      for j in -2..2:
        var
          offset = i + j
          pot_val = false

        if offset >= low(pots_in) and offset <= high(pots_in):
          pot_val = pots_in[offset]

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

  inc(gen)
  result = pots_new

var
  target_gen: int64 = 19
  sums = newSeq[int]()

if args["--part2"]:
  target_gen = (20 * 100) - 1
  #target_gen = 50000000000 - 1

proc checksum(pots_in: seq[bool]): int =
  var
    total = 0
  for i, p in pots_in:
    var
      offset = gen * 4

    if p == true:
      total += i - offset

    result = total

for i in 0..target_gen:
  pots = tick(pots)
  var sum = checksum(pots)
  if sums.contains(sum):
    echo "found repetition at generation=" & $gen
    break
  else:
    echo "[" & $gen & "] " & $sum
    sums.add(sum)

echo seq_to_str(pots)
echo $checksum(pots)
