package compiler;

import util.Error.error;
import compiler.analysis.name.SymbolTable;
import compiler.analysis.name.NameAnalysisVisitor;
import ast.*;
import visitor.BaseVisitor;

class CompilerVisitor extends BaseVisitor {

    var constantPool:ConstantPool;
    var symbolTable:SymbolTable;
    final program = new Output();
    var stack:Stack;
    public final fileOutput = new Output();
    var labelIndex = 0;

    var stackOffset = 0;

    public function new() {}

    function nextStack() {
        stack = stack.next();

        if (stack.address > stackOffset + 20) {
            error("Stack overflow.");
        }
    }

    function previousStack() {
        stack = stack.previous();
    }

    override function visitFile(node:FileNode) {
        fileOutput.writeInstruction("jmp", "program");

        stackOffset = fileOutput.length;
        fileOutput.writeComment("--- stack start ---");
        stack = new Stack(fileOutput.length);
        for (_ in 0...20) {
            fileOutput.writeInteger(0);
        }
        fileOutput.writeComment("--- stack end ---");

        final nameAnalysis = new NameAnalysisVisitor(fileOutput.length);
        node.accept(nameAnalysis);
        symbolTable = nameAnalysis.symbolTable;
        fileOutput.writeOutput(symbolTable.toAssembly());

        constantPool = new ConstantPool(fileOutput.length);

        for (n in node.nodes) {
            n.accept(this);
        }

        fileOutput.writeOutput(constantPool.toAssembly());

        fileOutput.writeComment("--- program start ---");
        fileOutput.writeLabel("program");
        fileOutput.writeOutput(program);
        fileOutput.writeComment("--- program end ---");
    }

    override function visitBlock(node:BlockNode) {
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    override function visitShow(node:ShowNode) {
        node.expression.accept(this);

        program.writeInstruction("ld", stack.address);
        previousStack();
        program.writeInstruction("mao");
    }

    override function visitBinaryExpression(node:BinaryExpressionNode) {
        node.left.accept(this);
        node.right.accept(this);

        final result = stack.previous();
        final s1 = stack.previous();
        final s2 = stack;

        switch (node.operation) {
            case Add:
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("add", s2.address);
                program.writeInstruction("st", result.address);
            case Subtract:
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("st", result.address);
            case Multiply:
                throw "Multiplication not implemented!";
            case Divide:
                throw "Division not implemented!";
            default: error('Operation ${node.operation} not supported in variable expressions.');
        }

        previousStack();
    }

    override function visitInteger(node:IntegerNode) {
        final address = constantPool.addConstant(node.value);

        nextStack();
        program.writeInstruction("ld", address);
        program.writeInstruction("st", stack.address);
    }

    override function visitVariableAssign(node:VariableAssignNode) {
        node.value.accept(this);

        final address = symbolTable.lookup(node.name);

        program.writeInstruction("ld", stack.address);
        program.writeInstruction("st", address);
        previousStack();
    }

    override function visitArrayAccess(node:ArrayAccessNode) {
        node.target.accept(this);
        final targetAddress = stack.address;

        node.index.accept(this);

        program.writeInstruction("ld", targetAddress);
        program.writeInstruction("add", stack.address);
        previousStack();
        program.writeInstruction("st", stack.address);
    }

    override function visitArrayAssign(node:ArrayAssignNode) {
        node.target.accept(this);
        final targetAddress = stack.address;

        node.value.accept(this);

        program.writeInstruction("ld", stack.address);
        previousStack();
        previousStack();
        program.writeInstruction("str", targetAddress);
    }

    function generateCondition(expression:ExpressionNode, jumpLabel:Int) {
        if (!(expression is BinaryExpressionNode)) { // TODO: Move to analysis phase?
            error("If expected binary expression");
        }

        final binaryExpression = cast(expression, BinaryExpressionNode);

        binaryExpression.left.accept(this);
        binaryExpression.right.accept(this);

        final s1 = stack.previous();
        final s2 = stack;

        switch (binaryExpression.operation) {
            case Equals:
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("brz", 'L$jumpLabel');
            case NotEquals:
                final endLabel = labelIndex++;
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("brz", 'L$endLabel');
                program.writeInstruction("jmp", 'L$jumpLabel');
                program.writeLabel('L${endLabel}');
            case GreaterThan:
                final endLabel = labelIndex++;
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("brz", 'L$endLabel');
                program.writeInstruction("brs", 'L$endLabel');
                program.writeInstruction("jmp", 'L$jumpLabel');
                program.writeLabel('L$endLabel');
            case LessThan:
                program.writeInstruction("ld", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("brs", 'L$jumpLabel');
            default: error('Operation ${binaryExpression.operation} not supported in conditions.');
        }

        previousStack();
        previousStack();
    }

    override function visitIdent(node:IdentNode) {
        final address = symbolTable.lookup(node.name);

        nextStack();
        program.writeInstruction("ld", constantPool.addConstant(address));
        program.writeInstruction("st", stack.address);
    }

    override function visitVariableAccess(node:VariableAccessNode) {
        node.value.accept(this);

        program.writeInstruction("ldr", stack.address);
        program.writeInstruction("st", stack.address);
    }

    override function visitIf(node:IfNode) {
        final l0Index = labelIndex++;
        final l1Index = labelIndex++;

        generateCondition(node.condition, l0Index);

        node.alternative.accept(this);
        program.writeInstruction("jmp", 'L$l1Index');

        program.writeLabel('L$l0Index');
        node.consequence.accept(this);
        program.writeLabel('L$l1Index');
    }

    override function visitWhile(node:WhileNode) {
        final l0Index = labelIndex++;
        final l1Index = labelIndex++;

        program.writeInstruction("jmp", 'L$l0Index');
        program.writeLabel('L$l1Index');

        node.body.accept(this);

        program.writeLabel('L$l0Index');
        generateCondition(node.condition, l1Index);
    }

    override function visitExit(node:ExitNode) {
        throw "Exit not implemented!";
    }
}