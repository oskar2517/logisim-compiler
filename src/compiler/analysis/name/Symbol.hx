package compiler.analysis.name;

class Symbol {

    public final symbolIndex:Int;
    public final size:Int;

    public function new(symbolIndex:Int, size:Int) {
        this.symbolIndex = symbolIndex;
        this.size = size;
    }
}