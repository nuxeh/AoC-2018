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
  elfA = 0#: ref DoublyLinkedNode[int]
  elfB = 0#: ref DoublyLinkedNode[int]

proc nth(n: int): DoublyLinkedNode[int] =
  var node: ref DoublyLinkedNode = recipeList.head
  for i in 0..<n:
    result = node.next

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 15

recipeList.append(7)
recipeList.append(6)
recipeList.append(5)
recipeList.append(4)
recipeList.append(3)
recipeList.append(2)

elfA = 0
elfB = 1

echo $recipeList & " " & $nth(elfB).value & " " & $nth(elfA).value
