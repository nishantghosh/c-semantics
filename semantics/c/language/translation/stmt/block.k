module C-STMT-BLOCK
     imports C-CONFIGURATION
     imports COMPAT-SYNTAX
     imports C-ABSTRACT-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-ENV-SYNTAX
     imports C-SYNTAX

     /*@ \fromStandard{\source[n1570]{\para{6.8.2}{2}}}{
     A \emph{compound statement} is a block.
     }*/
     rule BlockStatement(Block(Tag:Int, _, B:K)) => Block(Tag, B)

     rule <k> popBlock => .K ...</k>
          <elab>... .K => popBlock </elab>

     rule <k> Nop() => .K ...</k>
          <elab>... .K => Nop() </elab>

     // First block in a function.
     rule Block(Tag:Int, _, list(Statements:List))
          => Block(Tag, list(Statements))

     rule <k> Block(Tag:Int, list(Statements:List))
              => scope(blockScope(F, Base, Tag), listToK(Statements) ~> popBlock)
          ...</k>
          <curr-scope> blockScope(F:CId, Base::SymBase, _) </curr-scope>
          <block-history> .List => ListItem(Tag) ...</block-history>
          <elab>... .K => pushBlock(Tag) </elab>

endmodule
