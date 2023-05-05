grammar MathExpression {
    token TOP    { <sum> }
    rule sum     { <product>+ % '+' }
    rule product { <term>+ % '*' }
    rule term    { <number> | <group> }
    rule group   { '(' <sum> ')' }
    token number { \d+ }
}

# make => 制作数据结构, 例如 Hash
# made => 取出制作好的数据结果, 例如 Hash
class MathEvalAction {
    method TOP($/) {
        make $<sum>.made;
    }
    method sum($/) {
        make [+] $<product>».made;
    }
    method product($/) {
        make [*] $<term>».made;
    }
    method term($/) {
        make $/.values[0].made;
    }
    method group($/) {
        make $<sum>.made;
    }
    method number($/) {
        make $/.Int;
    }
}

my $match = MathExpression.parse(
    '4 + 5 * (1 + 3)',
    actions => MathEvalAction.new,
);

say $match.made;       # Output: 24
