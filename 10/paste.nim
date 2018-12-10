type
  Xy = tuple[
    x: int,
    y: int
  ]

type
  Point = tuple[
    position: Xy,
    velocity: Xy
  ]

var
  points = newSeq[Point]()

points.add(((1, 2), (2, 1)))

for p in mitems points:
  p.position.x = 2
  # paste.nim(19, 13) Error: 'p.position.x' cannot be assigned to

  p.position.x += p.velocity.x
  # paste.nim(22, 16) Error: type mismatch: got <int, int>
  # but expected one of:
  # proc `+=`[T: SomeOrdinal | uint | uint64](x: var T; y: T)
  #   for a 'var' type a variable needs to be passed, but 'p.position.x' is immutable
  # proc `+=`[T: float | float32 | float64](x: var T; y: T)
  #   first type mismatch at position: 1
  #   required type: var T: float or float32 or float64
  #   but expression 'p.position.x' is of type: int
  #   for a 'var' type a variable needs to be passed, but 'p.position.x' is immutable
  #
  # expression: p.position.x += p.velocity.x
