import streams
import strutils
import tables
import terminal

var
  file = newFileStream("input.txt", fmRead)
  line = ""
  sum = 0
  calibrations = newSeq[int]()
  sum2 = 0
  freq = initTable[int, int]()

if not isNil(file):
  while file.readLine(line):
    var i = parseInt(line)
    sum += i
    calibrations.add(i)
  file.close()
  styledEcho fgGreen, $sum

while true:
  for j in calibrations:
    sum2 += j
    if freq.hasKey(sum2):
      freq[sum2] = freq[sum2] + 1
    else:
      freq[sum2] = 1
    if freq[sum2] == 2:
      echo sum2
      quit()
