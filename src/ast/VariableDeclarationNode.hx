package ast;

import visitor.Visitor;

class VariableDeclarationNode extends Node {

    public final name:String;

    public function new(name:String) {
        this.name = name;
    }

    public function accept(visitor:Visitor) {
        visitor.visitVariableDeclaration(this);
    }
}