module C-EXPR-INC-AND-DEC
     imports C-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-ELABORATOR-SYNTAX
     imports C-TYPING-SYNTAX

     rule LV:Nclv ++
          => postOp(LV, ncle(LHOLE, type(LV)) := te(RHOLE, utype(LV)) + tv(1, utype(int)))
     rule LV:Nclv --
          => postOp(LV, ncle(LHOLE, type(LV)) := te(RHOLE, utype(LV)) - tv(1, utype(int)))

     context postOp(_, (HOLE:KItem => reval(HOLE))) [result(RValue)]
     rule postOp(LV:Nclv, Op:RValue) => te(postOp(nclvToLV(LV), Op), utype(LV))

     /*@ \fromStandard{\source[n1570]{\para{6.5.3.1}{2}}}{
     The value of the operand of the prefix \cinline{++} operator is
     incremented. The result is the new value of the operand after
     incrementation. The expression \cinline{++E} is equivalent to
     \cinline{(E+=1)}. See the discussions of additive operators and compound
     assignment for information on constraints, types, side effects, and
     conversions and the effects of operations on pointers.
     }*/
     rule ++ E:Nclv => E += tv(1, utype(int))

     /*@ \fromStandard{\source[n1570]{\para{6.5.3.1}{3}}}{
     The prefix \cinline{--} operator is analogous to the prefix \cinline{++}
     operator, except that the value of the operand is decremented.
     }*/
     rule -- E:Nclv => E -= tv(1, utype(int))

endmodule
