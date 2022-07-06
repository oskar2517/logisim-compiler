package ast;

import visitor.Visitor;

class IntegerNode extends ExpressionNode {

    public final value:Int;

    public function new(value:Int) {
        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitInteger(this);
    }
}