package ast;

import visitor.Visitor;

class ExitNode extends Node {

    public function new() {}

    public function accept(visitor:Visitor) {
        visitor.visitExit(this);
    }
}