let doc = """
Advent of code 2018, day 14

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
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

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 15

recipeList.append(3)
recipeList.append(7)

elfA = recipeList.head
elfB = recipeList.head.next

proc process() =
  var
    sum = elfA.value + elfB.value
    st = $sum

  for c in st:
    recipeList.append(parseInt($c))
  for i in 0..<(elfA.value + 1):
    elfA = elfA.next
  for i in 0..<(elfB.value + 1):
    elfB = elfB.next

echo $recipeList & " " & $elfA.value & " " & $elfB.value

process()
echo $recipeList & " " & $elfA.value & " " & $elfB.value

process()
echo $recipeList & " " & $elfA.value & " " & $elfB.value
