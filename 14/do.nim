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

recipeList.append(7)
recipeList.append(6)
recipeList.append(5)
recipeList.append(4)
recipeList.append(3)
recipeList.append(2)

proc process() =
  var i = 0
  for r in recipeList:
    echo $i & " " & $r
    inc(i)

elfA = recipeList.head
elfB = recipeList.head.next

process()

echo $recipeList & " " & $elfA.value & " " & $elfB.value

elfA = elfA.next
elfA = elfA.next
echo $recipeList & " " & $elfA.value & " " & $elfB.value
