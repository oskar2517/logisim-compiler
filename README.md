# Logisim Compiler
Compiler for a simple programming language designed to run on my CPU made with [Logisim evolution](https://github.com/logisim-evolution/logisim-evolution).

## Example
Implementation of the binary search algorithm:
```
var arr:10;
arr[0] = 1;
arr[1] = 3;
arr[2] = 6;
arr[3] = 7;
arr[4] = 10;
arr[5] = 11;
arr[6] = 15;
arr[7] = 16;
arr[8] = 20;
arr[9] = 24;

var needle = 15;

var n;
n = 10;

var mid;
var low;
var high;
high = n - 1;

while low < high + 1 {
    mid = (low + high) / 2;

    if needle == arr[mid] {
        show mid;
        exit;
    } else if needle < arr[mid] {
        high = mid - 1;
    } else {
        low = mid + 1;
    }
}

show -1;
```

https://user-images.githubusercontent.com/12718920/178802771-27053afd-f648-4685-a716-0eb6709f08ad.mp4

## Retargetting the code generator
The code generator can be retargetted by modifying [CompilerVisitor.hx](https://github.com/oskar2517/logsim-compiler/blob/main/src/compiler/CompilerVisitor.hx). 
It implements the [visitor pattern](https://en.wikipedia.org/wiki/Visitor_pattern).

