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
  Node = ref object
    children:seq[Node]
    packet: Packet

  Packet = object
    offset: int
    num_children: int
    num_meta: int
    meta: seq[int]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data_s = newSeq[string]()
  data = newSeq[int]()
  total_meta = 0

if not isNil(file):
  while file.readLine(line):
    data_s = splitWhitespace(line)
  file.close()

data = data_s.map(proc(s: string): int = parseInt(s))

echo $data

proc read_node(i: int): (int, int) =
  echo $i

  var
    num_children = data[i]
    num_meta = data[i + 1]
    meta_offset = 0
    packet_length = 0
    meta = newSeq[int]()
    child_size = newSeq[int]()
    value = 0

  echo "meta " & $num_meta

  for j in 0..<num_children:
    var
      sizes = read_node(i + 2 + meta_offset) # recurse
    echo "j=" & $j
    meta_offset += sizes[0]
    child_size.add(sizes[1])

  for k in 0..<num_meta:
    let offset = i + 2 + meta_offset + k
    echo "k=" & $k & " (" & $offset & ")"
    meta.add(data[offset])
    total_meta += data[offset]

  if num_children == 0 and len(meta) > 0:
    value += meta.foldl(a + b)
    echo "foldl: " & $value

  for k in 0..<num_meta:
    let
      child_offset = k - 1

    if child_offset < len(child_size) and child_offset >= 0:
      value += child_size[child_offset]

  echo "meta " & $num_meta

  packet_length = 2 + meta_offset + num_meta

  let node = (offset: i, num_children: num_children, num_meta: num_meta, meta: meta)
  echo $node & " length=" & $packet_length

  result = (packet_length, value)

echo len(data)
echo $read_node(0)

#[
var
  nodes = newSeq[Packet]
]#

echo $total_meta
