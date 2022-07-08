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

    public function new() {}

    function nextStack() {
        stack = stack.next();
    }

    function previousStack() {
        stack = stack.previous();
    }

    override function visitFile(node:FileNode) {
        fileOutput.writeInstruction("jmp", "program");

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

        program.writeInstruction("hlt");
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

        program.writeInstruction("lda", stack.address);
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
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("add", s2.address);
                program.writeInstruction("sta", result.address);
            case Subtract:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("sub", s2.address);
                program.writeInstruction("sta", result.address);
            case Multiply:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("mul", s2.address);
                program.writeInstruction("sta", result.address);
            case Divide:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("div", s2.address);
                program.writeInstruction("sta", result.address);
            default: error('Operation ${node.operation} not supported in variable expressions.');
        }

        previousStack();
    }

    override function visitInteger(node:IntegerNode) {
        final address = constantPool.addConstant(node.value);

        nextStack();
        program.writeInstruction("lda", address);
        program.writeInstruction("sta", stack.address);
    }

    override function visitVariableAssign(node:VariableAssignNode) {
        node.value.accept(this);

        final address = symbolTable.lookup(node.name);

        program.writeInstruction("lda", stack.address);
        program.writeInstruction("sta", address);
    }

    function generateCondition(expression:ExpressionNode, jumpLabel:Int) {
        if (!(expression is BinaryExpressionNode)) {
            error("If expected binary expression");
        }

        final binaryExpression = cast(expression, BinaryExpressionNode);

        binaryExpression.left.accept(this);
        binaryExpression.right.accept(this);

        final s1 = stack.previous();
        final s2 = stack;

        switch (binaryExpression.operation) {
            case Equals:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("cmp", s2.address);
                program.writeInstruction("bre", 'L$jumpLabel');
            case NotEquals:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("cmp", s2.address);
                program.writeInstruction("brn", 'L$jumpLabel');
            case GreaterThan:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("cmp", s2.address);
                program.writeInstruction("brg", 'L$jumpLabel');
            case LessThan:
                program.writeInstruction("lda", s1.address);
                program.writeInstruction("cmp", s2.address);
                program.writeInstruction("brl", 'L$jumpLabel');
            default: error('Operation ${binaryExpression.operation} not supported in conditions.');
        }
    }

    override function visitIdent(node:IdentNode) {
        final address = symbolTable.lookup(node.name);

        nextStack();
        program.writeInstruction("lda", constantPool.addConstant(address));
        program.writeInstruction("sta", stack.address);
    }

    override function visitVariableAccess(node:VariableAccessNode) {
        node.value.accept(this);

        program.writeInstruction("ldd", stack.address);
        program.writeInstruction("sta", stack.address);
    }

    override function visitArrayAccess(node:ArrayAccessNode) {
        node.target.accept(this);
        final targetAddress = stack.address;

        node.index.accept(this);

        program.writeInstruction("lda", targetAddress);
        program.writeInstruction("add", stack.address);
        previousStack();
        previousStack();
        program.writeInstruction("sta", stack.address);
    }

    override function visitArrayAssign(node:ArrayAssignNode) {
        node.target.accept(this);
        final targetAddress = stack.address;

        node.value.accept(this);

        previousStack();
        program.writeInstruction("stt", targetAddress);
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
        program.writeInstruction("hlt");
    }
}