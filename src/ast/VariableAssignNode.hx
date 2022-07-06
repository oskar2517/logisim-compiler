package ast;

import visitor.Visitor;

class VariableAssignNode extends Node {

    public final name:String;
    public final value:ExpressionNode;

    public function new(name:String, value:ExpressionNode) {
        this.name = name;
        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitVariableAssign(this);
    }
}