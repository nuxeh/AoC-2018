import strutils

var
  sum = 998

while sum > 0:
  echo $sum
  sum = sum div 10

proc printDigits(tot: int64) =
  var
    st = $tot

  for c in st:
    echo $c

printDigits(10)
printDigits(123123798123098132)

var
  str = "asdawe12ewqda"

echo str[4]
echo str[len($str) - 4]
