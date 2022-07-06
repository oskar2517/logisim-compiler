package compiler.analysis.name;

import ast.*;
import util.Error.error;
import visitor.BaseVisitor;

class NameAnalysisVisitor extends BaseVisitor {

    public final symbolTable:SymbolTable;

    public function new(startOffset:Int) {
        symbolTable = new SymbolTable(startOffset);
    }

    override function visitFile(node:FileNode) {
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    override function visitVariableDeclaration(node:VariableDeclarationNode) {
        if (symbolTable.exists(node.name)) {
            error('Re-declaration of variable ${node.name}.');
        }
        symbolTable.enter(node.name);
    }

    override function visitBlock(node:BlockNode) {
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    override function visitBinaryExpression(node:BinaryExpressionNode) {
        node.left.accept(this);
        node.right.accept(this);
    }

    override function visitShow(node:ShowNode) {
        node.expression.accept(this);
    }

    override function visitIdent(node:IdentNode) {
        if (!symbolTable.exists(node.name)) {
            error('Undefined variable ${node.name}.');
        }
    }

    override function visitVariableAssign(node:VariableAssignNode) {
        if (!symbolTable.exists(node.name)) {
            error('Undefined variable ${node.name}.');
        }
    }

    override function visitIf(node:IfNode) {
        node.condition.accept(this);
        node.consequence.accept(this);
        node.alternative.accept(this);
    }
}