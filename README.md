# Logisim Compiler
Compiler for a simple programming language designed to run on my CPU made with [Logisim evolution](https://github.com/logisim-evolution/logisim-evolution).

## Example
Implementation of the insertion sort algorithm:
```
var arr:5;
arr[0] = 4;
arr[1] = 23;
arr[2] = 1;
arr[3] = 7;
arr[4] = 12;

var len;
len = 5;

var r;
var j;
var i;
var x;
i = 1;
while i < len {
    x = arr[i];
    j = i - 1;

    r = 0;
    if j > -1 {
        if arr[j] > x {
            r = 1;
        }
    }

    while r == 1 {
        arr[j + 1] = arr[j];
        j = j - 1;

        r = 0;
        if j > -1 {
            if arr[j] > x {
                r = 1;
            }
        }
    }

    arr[j + 1] = x;

    i = i + 1;
}

i = 0;
while i < len {
    show arr[i];

    i = i + 1;
}
```

https://user-images.githubusercontent.com/12718920/178802771-27053afd-f648-4685-a716-0eb6709f08ad.mp4

## Retargetting the code generator
The code generator can be retargetted by modifying [CompilerVisitor.hx](https://github.com/oskar2517/logsim-compiler/blob/main/src/compiler/CompilerVisitor.hx). 
It implements the [visitor pattern](https://en.wikipedia.org/wiki/Visitor_pattern).

