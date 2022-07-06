package ast;

import visitor.Visitor;

class FileNode extends BlockNode {

    override function accept(visitor:Visitor) {
        visitor.visitFile(this);
    }
}