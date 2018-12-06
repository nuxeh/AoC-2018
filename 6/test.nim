import sequtils

type
  Point = tuple[
    x: int,
    y: int,
  ]

var
  data = newSeq[Point]()

data.add((1, 2))
data.add((2, 3))

echo $data

var
  test: int

# get maximum x

proc xmax(a: Point, b:Point): Point =
  if a.x > b.x:
    result = a
  else:
    result = b

test = data.foldl(xmax(a, b)).x

# what i'd really like to do...

#test = data.foldl(max(a[0], b[0]), 0)
# test.nim(31, 24) Error: type mismatch: got <int, int literal(0)>
# but expected one of:
# template `[]`(s: string; i: int): char
# proc `[]`[I: Ordinal; T](a: T; i: I): T
# proc `[]`[T](s: var openArray[T]; i: BackwardsIndex): var T
# proc `[]`[T, U](s: string; x: HSlice[T, U]): string
# proc `[]`(s: string; i: BackwardsIndex): char
# proc `[]`[T, U, V](s: openArray[T]; x: HSlice[U, V]): seq[T]
# proc `[]`[Idx, T](a: var array[Idx, T]; i: BackwardsIndex): var T
# proc `[]`[T](s: openArray[T]; i: BackwardsIndex): T
# proc `[]`[Idx, T](a: array[Idx, T]; i: BackwardsIndex): T
# proc `[]`[Idx, T, U, V](a: array[Idx, T]; x: HSlice[U, V]): seq[T]
#
# expression: [](a, 0)

#test = data.foldl(max(a.x, b.x), 0)
# test.nim(48, 24) Error: undeclared field: 'x'

proc what_value(a: int, b: Point): int  =
  echo $a
  echo $b
  result = 0

test = data.foldl(what_value(a, b), 0)


echo $data.foldl(max(a, b.x), 0)
echo $data.foldl(max(a, b.y), 0)

echo $test
