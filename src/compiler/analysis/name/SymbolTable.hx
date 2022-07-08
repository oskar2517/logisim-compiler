package compiler.analysis.name;

class SymbolTable {

    final startOffset:Int;
    var symbolIndex = 0;
    final symbols:Array<Symbol> = [];
    final keys:Array<String> = [];


    public function new(startOffset:Int) {
        this.startOffset = startOffset;
    }

    public function enter(name:String, size:Int) {
        symbols.push(new Symbol(symbolIndex, size));
        keys.push(name);
        symbolIndex += size; 
    }

    public function exists(name:String):Bool {
        return keys.contains(name);
    }

    public function lookup(name:String):Int {
        final index = Lambda.findIndex(keys, key -> key == name);

        return symbols[index].symbolIndex + startOffset;
    }

    public function getSize():Int {
        return symbolIndex - 1;
    }

    public function toAssembly():Output {
        final s = new Output();

        s.writeComment("--- symbol table start ---");
        for (i => symbol in symbols) {
            s.writeComment('${keys[i]} - ${symbol.symbolIndex + startOffset}');
            for (_ in 0...symbol.size) {
                s.writeInteger(0);
            }
        }
        s.writeComment("--- symbol table end ---");

        return s;
    }
}