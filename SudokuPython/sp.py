#! /c//Users/chien/AppData/Local/Programs/Python/Python312/python.exe

import sys

def seenCells(x,y):
    result = []
    # do the row and column
    for v in range(0,9):
      htuple = x,v
      vtuple = v,y
      if v != y:
        result.append(htuple)
      if v != x:
        result.append(vtuple)
    ulx = (x // 3) * 3
    uly = (y // 3) * 3
    for dx in range(0,3):
      for dy in range(0,3):
        t = ulx+dx,uly+dy
        # ignore the original cell, but also ignore everything in the same row and column
        # in the box (duplicates of the row and column cells above)
        if t[0] != x and t[1] != y:
          result.append(t)
    return result

# this method will do the work of adding a value to x,y
# before calling this, the caller must do the work of making the cell x,y = val, or this will fail
# returns a list of all cells where val was removed, or undef if something went wrong
# (x,y isn't val, or any cell looked at is empty)
# will not modify grid if undef is returned    
def apply(grid,x,y,val):
    if len(grid[y][x]) != 1 or val not in grid[y][x]:
        return None
        
    operands = seenCells(x,y)
    result = []
    
    for cell in operands:
      theSet = grid[cell[1]][cell[0]]
      if len(theSet) == 0:
        return None
      if val not in theSet: 
        continue
      if len(theSet) == 1:
        return None
      result.append(cell)
      
    # if we get here, result contains a list of the non-self cells in row, column, box that have val in them
    # and that no such cell is empty or will be emptied as a result of removing val
    
    # let's remove val
    for cell in result:
        grid[cell[1]][cell[0]].remove(val)
    
    return result
    
def reApply(grid,listthing,val):
    for cell in listthing:
        grid[cell[1]][cell[0]].add(val)

def nextX(x,y):
    if x == 8:
        return 0
    return x+1

def nextY(x,y):
    if x == 8:
        return y+1
    return y

def pprint(grid):
    for y in range(0,9):
        for x in range(0,9):
            print(max(grid[y][x]),end="")
        print()
    




def recurse(grid,x,y):
#    print(x,",",y)
    if x == 8 and y == 8:
        if len(grid[8][8]) == 1:
            print("Solution Found:")
            pprint (grid)
        return
    
    if len(grid[y][x]) == 0:
        return
        
    orig = grid[y][x]
    
    for val in orig:
        grid[y][x] = set(val)
        setters = apply(grid,x,y,val)
        if setters is None:
            continue
        recurse(grid,nextX(x,y),nextY(x,y))
        reApply(grid,setters,val)
    grid[y][x] = orig
    
       




if len(sys.argv) != 2:
    print("Bad Command Line")
    sys.exit(1)

f = open(sys.argv[1],"r")

lines = []

for x in f:
    x = x.strip()
    if len(x) != 9: 
        print("Bad line: " + x + " " + str(len(x)))
        sys.exit(1)
    lines.append(x)
    
if len(lines) != 9:
  print("Bad Line Count " + len(lines))
  sys.exit(1)
  
workspace = []
 
for y in range(0,9) :
  workspace.append([])
  for x in range(0,9):
    char = lines[y][x]
    if char == '.':
      workspace[y].append(set('123456789'))
    else:
      workspace[y].append(set(char))

        
recurse(workspace,0,0)

