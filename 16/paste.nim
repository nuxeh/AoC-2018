type
  Obj = object
    a: int
var
  objs = newSeq[Obj]()

for i in 0..<100:
  objs.add(Obj(a: 1))

echo $len(objs) # 100

type
  Obj3 = object
    a, b, c: int

  Obj2 = object
    a: int
    b: seq[int]
    c: seq[int]
    d: Obj3
var
  objs2 = newSeq[Obj2]()

for i in 0..<100:
  var o: Obj2
  #objs2.add(Obj2(a: 1, b: @[1, 2, 3, 4], c: @[1, 2, 3, 4]))
  objs2.add(o)

echo $len(objs2)
