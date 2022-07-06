package compiler.analysis.constant;

class ConstantPool {

    public final constants:Array<Int> = [];
    final startOffset:Int;

    public function new(startOffset:Int) {
        this.startOffset = startOffset;
    }

    public function getAddressOfConstant(constant:Int):Int {
        for (i => c in constants) {
            if (c == constant) {
                return i + startOffset;
            }
        }

        return -1;
    }

    public function addConstant(constant:Int) {
        if (getAddressOfConstant(constant) != -1) {
            return;
        }

        constants.push(constant);
    }

    public function getSize():Int {
        return constants.length;
    }

    public function toAssembly():Output {
        final s = new Output();

        s.writeComment("--- constant pool start ---");
        for (i => c in constants) {
            s.writeInteger(c);
        }
        s.writeComment("--- constant pool end ---");

        return s;
    }
}