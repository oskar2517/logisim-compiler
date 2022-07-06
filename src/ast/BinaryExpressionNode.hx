package ast;

import visitor.Visitor;

enum Operation {
    Add;
    Subtract;
    Multiply;
    Divide;
    LessThan;
    GreaterThan;
    Equals;
    NotEquals;
}

class BinaryExpressionNode extends ExpressionNode {

    public final operation:Operation;
    public final left:ExpressionNode;
    public final right:ExpressionNode;

    public function new(operation:Operation, left:ExpressionNode, right:ExpressionNode) {
        this.operation = operation;
        this.left = left;
        this.right = right;
    }

    public function accept(visitor:Visitor) {
        visitor.visitBinaryExpression(this);
    }
}