package ast;

import visitor.Visitor;

class ArrayAssignNode extends Node {

    public final target:Node;
    public final value:ExpressionNode;

    public function new(target:Node, value:ExpressionNode) {
        this.target = target;
        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitArrayAssign(this);
    }
}