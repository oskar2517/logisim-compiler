package compiler;

// TODO: check overflow
class Stack {

    public final address:Int;

    public function new(address:Int) {
        this.address = address;
    }

    public function next():Stack {
        return new Stack(address + 1);
    }

    public function previous():Stack {
        return new Stack(address - 1);
    }
}