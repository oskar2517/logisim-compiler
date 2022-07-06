package ast;

import visitor.Visitor;

class BlockNode extends Node {

    public final nodes:Array<Node> = [];

    public function new() {

    }

    public function addNode(node:Node) {
        nodes.push(node);
    }

    public function accept(visitor:Visitor) {
        visitor.visitBlock(this);
    }
}