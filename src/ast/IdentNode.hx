package ast;

import visitor.Visitor;

class IdentNode extends ExpressionNode {

    public final name:String;

    public function new(name:String) {
        this.name = name;
    }

    public function accept(visitor:Visitor) {
        visitor.visitIdent(this);
    }
}