import streams

var
  fs = newFileStream("input.txt", fmRead)
  line = ""

if not isNil(fs):
  while fs.readLine(line):
    echo line
  fs.close()
