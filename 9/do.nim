let doc = """
Advent of code 2018, day 9

Usage:
  day{} [options] [<input>]

Options:
  -h --help          Show this help message.
  -v --verbose       Show extra information.
  -t=<n> --test=<n>  Use test data
"""

import strutils
import docopt
import lists

type
  spec = tuple [
    players: int,
    last_score: int
  ]

var
  tests = newSeq[spec]()
  game: spec

tests.add((9, 10))
tests.add((9, 25))
tests.add((10, 1618))
tests.add((13, 7999))
tests.add((17, 1104))
tests.add((21, 6111))
tests.add((30, 5807))

let args = docopt(doc, version = "0.1.0")

if not args["--test"]:
  game.players = 419
  game.last_score = 7216400
else:
  var t = parseInt($args["--test"])
  if t < len(tests):
    game = tests[t]
  else:
    echo "invalid test"
    quit(1)

echo $game

var
  current_marble = 0
  current_player = 0
  table = initDoublyLinkedRing[int]()
  sequence = newSeq[int]()
  current_marble_index = 0
  current_node: ref DoublyLinkedNodeObj[int]
  scores = initCountTable[int]()

table.prepend(current_marble)
sequence.insert(current_marble, 0)
current_marble += 1

while current_marble < game.last_score:
  var insert_pos = (current_marble_index + 2) mod len(sequence)

  if args["--verbose"]:
    stdout.write "[" & $current_player & "] "
    for i, s in sequence:
      if i == current_marble_index:
        stdout.write " (" & $s & ") "
      else:
        stdout.write "  " & $s & "  "
    stdout.write '\n'

  if current_marble mod 23 == 0:
    scores.inc(current_player, current_marble)
    let seven_back = (current_marble_index + (len(sequence) - 7)) mod len(sequence)
    insert_pos = seven_back
    scores[current_player].inc(sequence[seven_back])
    sequence.delete(seven_back)
  else:
    sequence.insert(current_marble, insert_pos)

  current_marble += 1
  current_marble_index = insert_pos
  current_player = (current_player + 1) mod game.players


if args["--verbose"]:
  stdout.write "[" & $current_player & "] "
  for i, s in sequence:
   if i == current_marble_index:
     stdout.write " (" & $s & ") "
   else:
     stdout.write "  " & $s & "  "
  stdout.write '\n'

echo $scores
#echo $largest(scores)

echo "..."

var
  ring = initDoublyLinkedRing[int]()
  curmarb = 0
  curplayer = 0

ring.prepend(0)
ring.prepend(1)
ring.prepend(2)

proc draw_ring() =
  if args["--verbose"]:
    stdout.write "[" & $curplayer & "] "
    for node in nodes(ring):
      if node.value == curmarb:
        stdout.write " (" & $node.value & ") "
      else:
        stdout.write "  " & $node.value & "  "
    stdout.write '\n'
 
draw_ring()

echo $ring

proc insert_after(node, insert: ref DoublyLinkedNodeObj[int]) =
  node.value = 777
  insert.value = 888

  insert.prev = node
  insert.next = node.next
  insert.next.prev = insert
  node.next = insert

var
  added: ref DoublyLinkedNodeObj[int]

ring.prepend(3)
for newnode in nodes(ring):
  added = newnode
  for curr in nodes(ring):
    if curr.value == curmarb:
      insert_after(curr, newnode)
  break

#ring.remove(added)

echo $ring





type
  Node = ref object
    next:Node
    prev: Node
    value: int


# TODO: linked list in nim
# TODO: linked list or alternative in rust
