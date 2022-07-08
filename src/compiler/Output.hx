package compiler;

class Output {

    final buffer = new StringBuf();
    public var length(default, null) = 0;

    public function new() {}

    public function writeInstruction(opCode:String, immediate:Any = null) {
        buffer.add("    ");
        buffer.add(opCode);
        buffer.add(" ");
        if (immediate != null) {
            buffer.add(immediate);
        }
        buffer.add("\r\n");
        length++;
    }

    public function writeInteger(value:Int) {
        buffer.add("    ");
        buffer.add(value);
        buffer.add("\r\n");
        length++;
    }

    public function writeLabel(name:String) {
        buffer.add(name);
        buffer.add(":\r\n");
    }

    public function writeComment(comment:String) {
        buffer.add("// ");
        buffer.add(comment);
        buffer.add("\r\n");
    }

    public function writeOutput(out:Output) {
        buffer.add(out.toString());
        length += out.length;
    }

    public function toString():String {
        return buffer.toString();
    }
}