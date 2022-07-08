package ast;

import visitor.Visitor;

class ArrayAccessNode extends ExpressionNode {

    public final target:Node;
    public final index:ExpressionNode;

    public function new(target:Node, index:ExpressionNode) {
        this.target = target;
        this.index = index;
    }

    public function accept(visitor:Visitor) {
        visitor.visitArrayAccess(this);
    }
}