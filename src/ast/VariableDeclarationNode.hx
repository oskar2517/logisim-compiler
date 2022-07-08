package ast;

import visitor.Visitor;

class VariableDeclarationNode extends Node {

    public final name:String;
    public final size:Int;

    public function new(name:String, size:Int) {
        this.name = name;
        this.size = size;
    }

    public function accept(visitor:Visitor) {
        visitor.visitVariableDeclaration(this);
    }
}