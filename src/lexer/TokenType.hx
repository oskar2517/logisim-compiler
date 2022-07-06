package lexer;

enum TokenType {
    Integer;
    Ident;

    LParen;
    RParen;
    LBrace;
    RBrace;

    Plus;
    Minus;
    Asterisk;
    Slash;
    Assign;
    Equals;
    NotEquals;
    LessThan;
    GreaterThan;

    If;
    Else;
    While;
    Var;
    Show;
    Exit;

    Semicolon;
    Colon;
    Illegal;
    Eof;
}