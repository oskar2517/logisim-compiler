package compiler.analysis.constant;

import ast.*;
import visitor.BaseVisitor;

class ConstantsCollectorVisitor extends BaseVisitor {

    public final constantPool:ConstantPool;

    public function new(startOffset:Int) {
        constantPool = new ConstantPool(startOffset);
    }

    override function visitFile(node:FileNode) {
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    override function visitBlock(node:BlockNode) {
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    override function visitShow(node:ShowNode) {
        node.expression.accept(this);
    }

    override function visitBinaryExpression(node:BinaryExpressionNode) {
        node.left.accept(this);
        node.right.accept(this);
    }

    override function visitInteger(node:IntegerNode) {
        constantPool.addConstant(node.value);
    }

    override function visitVariableAssign(node:VariableAssignNode) {
        node.value.accept(this);
    }

    override function visitIf(node:IfNode) {
        node.condition.accept(this);
        node.consequence.accept(this);
        node.alternative.accept(this);
    }

    override function visitWhile(node:WhileNode) {
        node.condition.accept(this);
        node.body.accept(this);
    }
}