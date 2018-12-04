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

type
  Entry = tuple[
    year: int,
    month: int,
    day: int,
    hour: int,
    minute: int,
    id: int,
    typ: int,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[Entry]()

# [1518-11-01 00:00] Guard #10 begins shift
# [1518-11-01 00:05] falls asleep
# [1518-11-01 00:25] wakes up

if not isNil(file):
  var current_id = 0
  while file.readLine(line):
    var
      matches: array[6, string]
      entry: Entry

    #                    0      1      2     3     4              5
    if match(line, re"\[(\d*)\-(\d*)\-(\d*) (\d*):(\d*)\] Guard #(\d*) begins shift$", matches, 0):
      entry.year = parseInt(matches[0])
      entry.month = parseInt(matches[1])
      entry.day = parseInt(matches[2])
      entry.hour = parseInt(matches[3])
      entry.minute = parseInt(matches[4])
      entry.id = parseInt(matches[5])
      entry.typ = 0
      current_id = parseInt(matches[5])

    #                      0      1      2     3     4
    elif match(line, re"\[(\d*)\-(\d*)\-(\d*) (\d*):(\d*)\] wakes up", matches, 0):
      entry.year = parseInt(matches[0])
      entry.month = parseInt(matches[1])
      entry.day = parseInt(matches[2])
      entry.hour = parseInt(matches[3])
      entry.minute = parseInt(matches[4])
      entry.typ = 1
      entry.id = current_id

    #                      0      1      2     3     4
    elif match(line, re"\[(\d*)\-(\d*)\-(\d*) (\d*):(\d*)\] falls asleep$", matches, 0):
      entry.year = parseInt(matches[0])
      entry.month = parseInt(matches[1])
      entry.day = parseInt(matches[2])
      entry.hour = parseInt(matches[3])
      entry.minute = parseInt(matches[4])
      entry.typ = 2
      entry.id = current_id

    data.add(entry)

  file.close()

echo len(data)

var
  guard_timeline: array[60, int]
  sleep_totals = initTable[int, int]()
  start_time = 0
  timeline = initTable[int, array[60, int]]()

var
  new_array: array[60, int]

for e in data:
  if (e.typ == 0): # starts
    for i in 0..59:
      guard_timeline[i] = 0


  elif (e.typ == 1): # wakes up
    for i in start_time..<e.minute:
      guard_timeline[i] += 1
      if hasKeyOrPut(timeline, e.id, new_array):
        timeline[e.id][i] += 1

    # print
    for i in 0..59:
      if guard_timeline[i] == 0:
        stdout.write " "
      else:
        stdout.write "#"
    stdout.write "\n"

    # update sleep count
    if hasKeyOrPut(sleep_totals, e.id, 0):
      sleep_totals[e.id] += e.minute - start_time

  elif (e.typ == 2): # falls asleep
    start_time = e.minute

var
  longest_asleep = -1
  guard_longest_asleep = -1
  longest_minute = -1
  longest_minute_n = -1

# print times asleep
echo "total times asleep:"
for k, t in sleep_totals:
  echo $k & ": " & $t

  if t > longest_asleep:
    longest_asleep = t
    guard_longest_asleep = k

echo "guard longest asleep: " & $guard_longest_asleep

for k, m in timeline:
  echo $k & ": " & $m

# get minute longest asleep
for i, m in timeline[guard_longest_asleep]:
  if m > longest_minute:
    longest_minute = m
    longest_minute_n = i

echo "longest minute: " & $longest_minute_n

echo "result: " & $(guard_longest_asleep * longest_minute_n)
