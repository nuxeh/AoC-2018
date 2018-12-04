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
      current_id = parseInt(matches[5])

    #                      0      1      2     3     4
    elif match(line, re"\[(\d*)\-(\d*)\-(\d*) (\d*):(\d*)\] wakes up", matches, 0):
      entry.year = parseInt(matches[0])
      entry.month = parseInt(matches[1])
      entry.day = parseInt(matches[2])
      entry.hour = parseInt(matches[3])
      entry.minute = parseInt(matches[4])
      entry.id = current_id

    #                      0      1      2     3     4
    elif match(line, re"\[(\d*)\-(\d*)\-(\d*) (\d*):(\d*)\] falls asleep$", matches, 0):
      entry.year = parseInt(matches[0])
      entry.month = parseInt(matches[1])
      entry.day = parseInt(matches[2])
      entry.hour = parseInt(matches[3])
      entry.minute = parseInt(matches[4])
      entry.id = current_id

    data.add(entry)

  file.close()

echo len(data)
for entry in data:
  echo $entry
