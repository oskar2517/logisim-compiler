package ast;

import visitor.Visitor;

class IfNode extends Node {

    public final condition:ExpressionNode;
    public final consequence:BlockNode;
    public final alternative:BlockNode;

    public function new(condition:ExpressionNode, consequence:BlockNode, alternative:BlockNode) {
        this.condition = condition;
        this.consequence = consequence;
        this.alternative = alternative;
    }

    public function accept(visitor:Visitor) {
        visitor.visitIf(this);
    }
}