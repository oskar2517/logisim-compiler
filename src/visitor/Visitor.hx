package visitor;

import ast.*;

interface Visitor {

    function visitArrayAccess(node:ArrayAccessNode):Void;

    function visitArrayAssign(node:ArrayAssignNode):Void;

    function visitBinaryExpression(node:BinaryExpressionNode):Void;

    function visitBlock(node:BlockNode):Void;

    function visitExit(node:ExitNode):Void;

    function visitFile(node:FileNode):Void;

    function visitIdent(node:IdentNode):Void;

    function visitIf(node:IfNode):Void;

    function visitInteger(node:IntegerNode):Void;

    function visitShow(node:ShowNode):Void;

    function visitVariableAccess(node:VariableAccessNode):Void;

    function visitVariableAssign(node:VariableAssignNode):Void;
    
    function visitVariableDeclaration(node:VariableDeclarationNode):Void;

    function visitWhile(node:WhileNode):Void;
}