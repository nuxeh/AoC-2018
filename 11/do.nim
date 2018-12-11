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

echo $calc(8, 3, 5)
echo $calc(57, 122, 79)
echo $calc(39, 217, 196)
echo $calc(71, 101, 153)

proc evaluate(grid: array[300, array[300, int]], x, y, s: int): int =
  var sum = 0
  for i in 0..s-1:
    for j in 0..s-1:
      sum += grid[y+i][x+j]
  result = sum

proc go(i, s: int): (int, (int, int, int)) =
  var
    grid: array[300, array[300, int]]
    largest: (int, int, int)
    largest_val = 0
  
  for y in low(grid)..high(grid):
    for x in low(grid[y])..high(grid[y]):
      grid[y][x] = calc(i, x, y)

  for y in low(grid)..(high(grid) - s - 1):
    for x in low(grid[y])..(high(grid[y]) - s - 1):
      var
        v = evaluate(grid, x, y, s)
      if v > largest_val:
        largest = (y, x, s)
        largest_val = v

  #echo "[" & $largest[1] & "," & $largest[0] & "," & $largest[2] & "] -> " & $largest_val
  result = (largest_val, largest)

echo $go(18, 3)
echo $go(42, 3)
echo $go(input, 3) # part 1

echo $go(18, 10)
echo $go(42, 100)
echo $go(42, 300)

proc part2(ip: int) =
  var
    largest: (int, int, int)
    largest_val = 0

  for i in 1..300:
    var
      v = go(ip, i)
    if v[0] > largest_val:
      largest = v[1]
      largest_val = v[0]

  echo "[" & $largest[1] & "," & $largest[0] & "," & $largest[2] & "] -> " & $largest_val

#part2(18)
#part2(42)
part2(input)

var grid = [[1, 1, 1], [2, 2, 2], [3, 3, 3]]

proc evaluate2(grid: array[3, array[3, int]], x, y: int): int =
  var sum = 0
  for i in 0..2:
    for j in 0..2:
      sum += grid[y+i][x+j]
  result = sum

for y in low(grid)..high(grid):
  for x in low(grid[y])..high(grid[y]):
    stdout.write $grid[y][x] & " "
  stdout.write '\n'

echo $evaluate2(grid, 0, 0)
