package lexer;

private final keywords = [
    "if" => TokenType.If, 
    "else" => TokenType.Else, 
    "while" => TokenType.While,
    "var" => TokenType.Var,
    "show" => TokenType.Show,
    "exit" => TokenType.Exit,
    "array" => TokenType.Array
];

function isKeyword(ident:String):Bool {
    return keywords.get(ident) != null;
}

function getKeywordType(ident:String):TokenType {
    return keywords[ident];
}