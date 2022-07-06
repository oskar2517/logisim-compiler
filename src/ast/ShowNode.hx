package ast;

import visitor.Visitor;

class ShowNode extends Node {

    public final expression:ExpressionNode;

    public function new(expression:ExpressionNode) {
        this.expression = expression;
    }

    public function accept(visitor:Visitor) {
        visitor.visitShow(this);
    }
}