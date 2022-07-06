package ast;

import visitor.Visitor;

class WhileNode extends Node {

    public final condition:ExpressionNode;
    public final body:BlockNode;

    public function new(condition:ExpressionNode, body:BlockNode) {
        this.condition = condition;
        this.body = body;
    }

    public function accept(visitor:Visitor) {
        visitor.visitWhile(this);
    }
}