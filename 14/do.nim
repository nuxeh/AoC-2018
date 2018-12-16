let doc = """
Advent of code 2018, day 14

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test input.
  -s=<stop>       Stoping point
  --part2         Process part 2
"""
import re
import docopt
import terminal
import streams
import strutils
import sequtils
import algorithm
import tables
import sets
import lists
import typetraits

var
  input = 633601
  recipeList = initDoublyLinkedRing[int]()
  elfA: DoublyLinkedNode[int]
  elfB: DoublyLinkedNode[int]
  nodesAdded = 2

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 15

if args["-s"]:
  input = parseInt($args["-s"])

var
  inputStr = $input
  inputStrLen = len(inputStr)

recipeList.append(3)
recipeList.append(7)

elfA = recipeList.head
elfB = recipeList.head.next

echo "input=" & $input & " (" & $inputStrLen & ")"

proc process() =
  var
    sum = elfA.value + elfB.value
    st = $sum

  for c in st:
    recipeList.append(parseInt($c))
    inc(nodesAdded)
  for i in 0..<(elfA.value + 1):
    elfA = elfA.next
  for i in 0..<(elfB.value + 1):
    elfB = elfB.next

while true:
  process()
  if args["--verbose"]:
    echo $recipeList & " " & $elfA.value & " " & $elfB.value

  # part 2
  if args["--part2"]:
    var match = true
    for node in nodes(recipeList):
      var
        curr = node
      for i in 0..<inputStrLen:
        if args["--verbose"]:
          echo $i & " " & $inputStr[i] & " " & $curr.value & " " & $(parseInt($inputStr[i]) == curr.value)
        if $inputStr[i] != $curr.value:
          match = false
          break
        curr = curr.next
      if match: break
    if match:
      echo $(nodesAdded - inputStrLen)
      break

  # part 1
  else:
    if nodesAdded > input + 10:
      var i = 0
      for node in recipeList:
        if i >= input and i < input + 10:
          stdout.write $node
        inc(i)
      stdout.write '\n'
      break
