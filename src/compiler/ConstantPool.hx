package compiler;

class ConstantPool {

    public final constants:Array<Int> = [];
    final startOffset:Int;

    public function new(startOffset:Int) {
        this.startOffset = startOffset;
    }

    public function addConstant(constant:Int) {
        for (i => c in constants) {
            if (c == constant) {
                return i + startOffset;
            }
        }

        constants.push(constant);

        return constants.length - 1 + startOffset;
    }

    public function getSize():Int {
        return constants.length;
    }

    public function toAssembly():Output {
        final s = new Output();

        s.writeComment("--- constant pool start ---");
        for (i => c in constants) {
            s.writeComment(Std.string(i + startOffset));
            s.writeInteger(c);
        }
        s.writeComment("--- constant pool end ---");

        return s;
    }
}