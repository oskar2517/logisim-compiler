package compiler.analysis.name;

import haxe.ds.StringMap;

class SymbolTable {

    final startOffset:Int;
    var symbolIndex = 0;
    final symbols:StringMap<Symbol> = new StringMap();

    public function new(startOffset:Int) {
        this.startOffset = startOffset;
    }

    public function enter(name:String, size:Int) {
        symbols.set(name, new Symbol(symbolIndex, size));
        symbolIndex += size; 
    }

    public function exists(name:String):Bool {
        return symbols.exists(name);
    }

    public function lookup(name:String):Int {
        return symbols.get(name).symbolIndex + startOffset;
    }

    public function getSize():Int {
        return symbolIndex - 1;
    }

    public function toAssembly():Output {
        final s = new Output();

        s.writeComment("--- symbol table start ---");
        for (name => symbol in symbols) {
            s.writeComment('$name - ${symbol.symbolIndex + startOffset}');
            for (_ in 0...symbol.size) {
                s.writeInteger(0);
            }
        }
        s.writeComment("--- symbol table end ---");

        return s;
    }
}