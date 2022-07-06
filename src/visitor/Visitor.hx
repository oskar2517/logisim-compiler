package visitor;

import ast.*;

interface Visitor {

    function visitBinaryExpression(node:BinaryExpressionNode):Void;

    function visitBlock(node:BlockNode):Void;

    function visitExit(node:ExitNode):Void;

    function visitFile(node:FileNode):Void;

    function visitIdent(node:IdentNode):Void;

    function visitIf(node:IfNode):Void;

    function visitInteger(node:IntegerNode):Void;

    function visitShow(node:ShowNode):Void;

    function visitVariableAssign(node:VariableAssignNode):Void;
    
    function visitVariableDeclaration(node:VariableDeclarationNode):Void;

    function visitWhile(node:WhileNode):Void;
}