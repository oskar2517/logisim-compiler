package parser;

import ast.BinaryExpressionNode.Operation;
import util.Error.error;
import haxe.format.JsonPrinter;
import sys.io.File;
import lexer.*;
import ast.*;

class Parser {
    final lexer:Lexer;
    public final ast = new FileNode();
    var currentToken:Token;
    var assemblerConfigParsed = false;

    public function new(lexer:Lexer) {
        this.lexer = lexer;

        currentToken = lexer.readToken();
    }

    function expectToken(type:TokenType) {
        if (currentToken.type != type) {
            error('Unexpected token type ${currentToken.type}, expected $type.');
        }
    }

    public function parse() {
        while (currentToken.type != Eof) {
            parseGlobal(ast);
        }
    }

    public function writeAst() {
        File.saveContent("ast.json", JsonPrinter.print(ast));
    }

    function nextToken() {
        currentToken = lexer.readToken();
    }

    function parseExpression():ExpressionNode {
        return parseComparison();
    }

    function parseComparison():ExpressionNode {
        var left = parseNumeric();

        while (true) {
            final type:Operation = switch (currentToken.type) {
                case LessThan: LessThan;
                case GreaterThan: GreaterThan;
                case Equals: Equals;
                case NotEquals: NotEquals;
                default: break;
            }

            nextToken();
            final right = parseNumeric();
            left = new BinaryExpressionNode(type, left, right);
        }

        return left;
    }

    function parseNumeric():ExpressionNode {
        var left = parseTerm();

        while (true) {
            final type:Operation = switch (currentToken.type) {
                case Plus: Add;
                case Minus: Subtract;
                default: break;
            }

            nextToken();
            final right = parseTerm();
            left = new BinaryExpressionNode(type, left, right);
        }

        return left;
    }

    function parseTerm():ExpressionNode {
        var left = parseSignedFactor();

        while (true) {
            final type:Operation = switch (currentToken.type) {
                case Asterisk: Multiply;
                case Slash: Divide;
                default: break;
            }

            nextToken();
            final right = parseSignedFactor();
            left = new BinaryExpressionNode(type, left, right);
        }

        return left;
    }

    function parseSignedFactor():ExpressionNode {
        return if (currentToken.type == Minus) {
            nextToken();

            final right = parseFactor();

            new BinaryExpressionNode(Subtract, new IntegerNode(0), right);
        } else {
            parseFactor();
        }
    }

    function parseFactor():ExpressionNode {
        return switch (currentToken.type) {
            case LParen:
                nextToken();
                final comparison = parseComparison();

                expectToken(RParen);
                nextToken();

                comparison;
            case Integer:
                parseInteger();
            case Ident:
                parseVariableAcceess();
            default:
                error('Unexpected token type ${currentToken.type}, expected expression.');
                null;
        }
    }

    function parseVariableAcceess():VariableAccessNode {
        var left:ExpressionNode = parseIdent();

        while (currentToken.type == LBrack) {
            nextToken();

            final index = parseExpression();
            expectToken(RBrack);
            nextToken();

            left = new ArrayAccessNode(left, index);
        }

        return new VariableAccessNode(left);
    }

    function parseIdent():IdentNode {
        expectToken(Ident);
        final name = currentToken.literal;
        nextToken();

        return new IdentNode(name);
    }

    function parseInteger():IntegerNode {
        final n = Std.parseInt(currentToken.literal);
        nextToken();
        return new IntegerNode(n);
    }

    function parseShow():ShowNode {
        expectToken(Show);
        nextToken();
        final expression = parseExpression();
        expectToken(Semicolon);
        nextToken();

        return new ShowNode(expression);
    }

    function parseVariableDeclaration():VariableDeclarationNode {
        expectToken(Var);
        nextToken();
        final name = currentToken.literal;
        nextToken();
        final size = if (currentToken.type == Colon) {
            nextToken();
            expectToken(Integer);
            final size = Std.parseInt(currentToken.literal);
            nextToken();

            size;
        } else {
            1;
        }
        expectToken(Semicolon);
        nextToken();

        return new VariableDeclarationNode(name, size);
    }

    function parseVariableAssign():Node {
        expectToken(Ident);

        return if (lexer.peekToken().type == Assign) {
            final name = currentToken.literal;
            nextToken();
            expectToken(Assign);
            nextToken();
            final value = parseExpression();
            expectToken(Semicolon);
            nextToken();
    
            new VariableAssignNode(name, value);
        } else {
            final target = parseVariableAcceess().value;
            expectToken(Assign);
            nextToken();
            final value = parseExpression();
            expectToken(Semicolon);
            nextToken();

            new ArrayAssignNode(target, value);
        }
    }

    function parseBlock():BlockNode {
        expectToken(LBrace);
        nextToken();

        final block = new BlockNode();

        while (currentToken.type != RBrace) {
            if (currentToken.type == Eof) {
                error("Unexted end of file.");
            }

            parseLocal(block);
        }

        expectToken(RBrace);
        nextToken();

        return block;
    }

    function parseIf() {
        expectToken(If);
        nextToken();

        final condition = parseExpression();

        final consequence = parseBlock();
        var alternative = new BlockNode();
    
        if (currentToken.type == Else) {
            nextToken();

            alternative = parseBlock();
        }

        return new IfNode(condition, consequence, alternative);
    }

    function parseWhile():WhileNode {
        expectToken(While);
        nextToken();

        final condition = parseExpression();
        final body = parseBlock();

        return new WhileNode(condition, body);
    }

    function parseExit():ExitNode {
        expectToken(Exit);
        nextToken();
        expectToken(Semicolon);
        nextToken();

        return new ExitNode();
    }

    function parseLocal(block:BlockNode) {
        switch (currentToken.type) {
            case Show: block.addNode(parseShow());
            case Ident: block.addNode(parseVariableAssign());
            case If: block.addNode(parseIf());
            case While: block.addNode(parseWhile());
            case Exit: block.addNode(parseExit());
            case Illegal: error('Illegal token ${currentToken.literal}.');
            default: error('Unexpected token type ${currentToken.type}.');
        }
    }

    function parseGlobal(block:BlockNode) {
        switch (currentToken.type) {
            case Show: block.addNode(parseShow());
            case Var: block.addNode(parseVariableDeclaration());
            case Ident: block.addNode(parseVariableAssign());
            case If: block.addNode(parseIf());
            case While: block.addNode(parseWhile());
            case Exit: block.addNode(parseExit());
            case Illegal: error('Illegal token ${currentToken.literal}.');
            default: error('Unexpected token type ${currentToken.type}.');
        }
    }
}