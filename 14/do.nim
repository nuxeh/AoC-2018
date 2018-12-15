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
  recipeListA = initDoublyLinkedRing[int]()
  recipeListB = initDoublyLinkedRing[int]()

proc append(i: int) =
  recipeListA.append(i)
  recipeListB.append(i)

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 15

append(7)
append(3)
recipeListB.head = recipeListB.head.next

echo $recipeListA & " " & $recipeListA.head.value
echo $recipeListB & " " & $recipeListB.head.value
