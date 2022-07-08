package lexer;

enum TokenType {
    Integer;
    Ident;

    LParen;
    RParen;
    LBrace;
    RBrace;
    LBrack;
    RBrack;

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
    Array;

    Semicolon;
    Colon;
    Illegal;
    Eof;
}