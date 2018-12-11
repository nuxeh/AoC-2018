let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
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
  input = 1309
  grid: array[300, array[300, int]]

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  input = 18

proc calc(i, x, y: int): int =
  var
    rack_id = x + 10
    power_level: int = rack_id * y

  power_level += i
  power_level *= rack_id
  power_level = power_level div 100
  power_level = power_level mod 10
  power_level -= 5

  result = power_level

for y in low(grid)..high(grid):
  for x in low(grid[y])..high(grid[y]):
    grid[x][y] = calc(input, x, y)

#[
for y in low(grid)..high(grid):
  for x in low(grid[y])..high(grid[y]):
    stdout.write $grid[x][y] & " "
  stdout.write '\n'
]#

echo $calc(8, 3, 5)
echo $calc(57, 122, 79)
echo $calc(39, 217, 196)
echo $calc(71, 101, 153)

proc evaluate(x, y: int): int =
  var sum = 0
  for i in 0..2:
    for j in 0..1:
      sum += grid[x+i][y+j]
  result = sum

var
  counts = initCountTable[string]()

for y in low(grid)..(high(grid) - 2):
  for x in low(grid[y])..(high(grid[y]) - 2):
    var
      key = $(x + 1) & "," & $(y + 1)
    counts.inc(key, evaluate(x, y))

echo $largest(count).key & ": " &largest(count).val
