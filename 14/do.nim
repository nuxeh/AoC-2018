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

var
  input = 633601
  recipeList = initSinglyLinkedList[int]()

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 15

recipeList.prepend(7)
recipeList.prepend(3)

echo $recipeList
