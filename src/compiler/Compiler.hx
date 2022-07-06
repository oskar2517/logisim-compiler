package compiler;

import ast.FileNode;

class Compiler {

    public static function compile(node:FileNode):String {
        final compilerVisitor = new CompilerVisitor();
        node.accept(compilerVisitor);
        
        return compilerVisitor.fileOutput.toString();
    }
}