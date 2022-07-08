package ast;

import visitor.Visitor;

class VariableAccessNode extends ExpressionNode {

    public final value:ExpressionNode;

    public function new(value:ExpressionNode) {
        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitVariableAccess(this);
    }
}