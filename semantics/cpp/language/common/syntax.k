module CPP-SORTS
     syntax CId ::= OpId

     syntax Init ::= Stmt | Expr

     syntax NoArg

     syntax Expr ::= Name

     syntax Name

     syntax Stmt ::= Block

     syntax Block

     syntax OpId

     syntax RefQualifier

     syntax Tag

     syntax AccessSpecifier
endmodule

module CPP-SYNTAX
     imports CPP-SORTS
     imports INT-SYNTAX
     imports LIST
     imports COMMON-SORTS
     imports CPP-DYNAMIC-SORTS
     imports CPP-REVAL-SYNTAX
     imports CPP-TYPING-SORTS
     imports COMPAT-SORTS

     syntax OpId ::= "operatornew"
                   | "operatordelete"
                   | "operatornew[]"
                   | "operatordelete[]"
                   | "operator+"
                   | "operator-"
                   | "operator*"
                   | "operator/"
                   | "operator%"
                   | "operator^"
                   | "operator&"
                   | "operator|"
                   | "operator~"
                   | "operator!"
                   | "operator="
                   | "operator<"
                   | "operator>"
                   | "operator+="
                   | "operator-="
                   | "operator*="
                   | "operator/="
                   | "operator%="
                   | "operator^="
                   | "operator&="
                   | "operator|="
                   | "operator<<"
                   | "operator>>"
                   | "operator<<="
                   | "operator>>="
                   | "operator=="
                   | "operator!="
                   | "operator<="
                   | "operator>="
                   | "operator&&"
                   | "operator||"
                   | "operator++"
                   | "operator--"
                   | "operator,"
                   | "operator->*"
                   | "operator->"
                   | "operator()"
                   | "operator[]"

     // not technically operator ids, but used internally in order to process
     // syntax from the parser
     syntax OpId ::= "operator."
                   | "operator.*"
                   | "operator?"
                   | "operator_++"
                   | "operator++_"
                   | "operator_--"
                   | "operator--_"

     syntax Specifier ::= Alignas(Int)

     syntax Expr ::= temp(Int, CPPType)
                   | newSize(Int)

     syntax DestructorId ::= DestructorId(CId)

     syntax CId ::= DestructorId
                  | ConstructorId(CId)
                  | ConversionId(CPPType)

     syntax ClassKey ::= Struct() | Union() | Class()

     syntax Tag ::= ClassKey | Enum() | Typename() | NoTag()

     syntax AccessSpecifier ::= Public() | Private() | Protected() | NoAccessSpec()

     syntax RefQualifier ::= RefLValue() | RefRValue() | RefNone()

     syntax TemplateKeyword ::= "template" | "no-template"

     // for trace
     syntax Expr ::= CallExpr(Expr, StrictList) [klabel(CallExpr2)]

     syntax Expr ::= ResolvedExpr

     syntax ResolvedExpr ::= left:
                     Expr "[" Expr "]" [strict]
                   | Expr "++" [strict]
                   | Expr "--" [strict]
                   | BuiltinCallOp(Expr, Bool, List)
                   | ReinterpretCast(AType, Expr) [strict]
                   | ConstCast(AType, Expr) [strict]
                   > right:
                     "++" Expr [strict]
                   | "--" Expr [strict]
                   | NewOp(CPPType, Expr, K, K, Int)
                   | DeleteOp(Expr, Expr, K, Int)
                   | "*" Expr
                   | "&" Expr

                   // like & but applies to all objects including xvalues and class prvalues
                   | getAddress(Expr) [strict]
                   | "!" Expr
                   | "-" Expr
                   | "+" Expr
                   | "~" Expr
                   | Expr "." TemplateKeyword Name
                   | Expr "->" TemplateKeyword Name
                   > left:
                     Expr ".*" Expr
                   | Expr "->*" Expr
                   > left:
                     Expr "*" Expr
                   | Expr "/" Expr
                   | Expr "%" Expr
                   > left:
                     Expr "+" Expr
                   | Expr "-" Expr
                   > left:
                     Expr "<<" Expr
                   | Expr ">>" Expr
                   > left:
                     Expr "<" Expr
                   | Expr "<=" Expr
                   | Expr ">" Expr
                   | Expr ">=" Expr
                   > left:
                     Expr "==" Expr
                   | Expr "!=" Expr
                   > left:
                     Expr "&" Expr
                   > left:
                     Expr "^" Expr
                   > left:
                     Expr "|" Expr
                   > left:
                     Expr "&&" Expr
                   > left:
                     Expr "||" Expr
                   > right:
                     Expr ":=" Init [strict(1)]
                   | Expr ":=init" Init [strict(1)]
                   | Expr "+=" Init [strict(1)]
                   | Expr "-=" Init [strict(1)]
                   | Expr "*=" Init [strict(1)]
                   | Expr "/=" Init [strict(1)]
                   | Expr "%=" Init [strict(1)]
                   | Expr "^=" Init [strict(1)]
                   | Expr "&=" Init [strict(1)]
                   | Expr "|=" Init [strict(1)]
                   | Expr "<<=" Init [strict(1)]
                   | Expr ">>=" Init [strict(1)]
                   | ConditionalOp(Expr, Expr, Expr, ValueCategory, CPPType)
                   | ThrowOp(Expr) [strict]
                   > left:
                     Comma(Expr, Expr) [strict(1)]
     syntax Name ::= Name(NNS, CId)
                   | Name(NNS, CId, List)

     syntax ExecName ::= ExecName(NNS, CId)

     syntax Expr ::= ExecName

     syntax Expr ::= ConvertType(CPPType, Expr)
                   | ExprLoc

     syntax ExprLoc ::= ExprLoc(CabsLoc, Expr)

     syntax Init ::= ExprLoc(CabsLoc, Init)

     syntax BraceInit ::= ExprLoc(CabsLoc, BraceInit)

     syntax Block ::= BlockStmt(Int, List)

     syntax Decl

     syntax Stmt ::= LabelStmt(CId, List)
                   | GotoStmt(CId)
                   | ExpressionStmt(Expr) [strict]
                   | PRValExpressionStmt(Expr) [strict]
                   | BreakStmt()
                   | ReturnOp(Expr)
                   | IfStmt(Decl, Stmt, Stmt)
                   | IfStmt(Expr, K, K)
                   | WhileStmt(Decl, Stmt)
                   | WhileStmt(Expr, K)
                   | ForStmt(Expr, K, K) [klabel(ForStmt3)]
                   | TryStmt(K, List)
                   | CatchOp(CPPType, K)
                   | CatchAnyOp(K)

     // returns the current exception object. Used to initialize
     // catch declarations.
     syntax Expr ::= exceptionObject(CPPType)

endmodule

module CPP-SYNTAX-HEATING
     imports CPP-SYNTAX
     imports C-CONFIGURATION

     context <k> _ := (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ := (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ :=init (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ :=init (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ += (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ += (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ -= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ -= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ *= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ *= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ /= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ /= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ %= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ %= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ ^= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ ^= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ &= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ &= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ |= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ |= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ <<= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ <<= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ >>= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ >>= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> * (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> * (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) + _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) + _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ + (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ + (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) - _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) - _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ - (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ - (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) * _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) * _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ * (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ * (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) / _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) / _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ / (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ / (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) % _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) % _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ % (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ % (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) ^ _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) ^ _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ ^ (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ ^ (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) & _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) & _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ & (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ & (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) | _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) | _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ | (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ | (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) != _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) != _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ != (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ != (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) == _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) == _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ == (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ == (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) < _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) < _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ < (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ < (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) <= _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) <= _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ <= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ <= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) > _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) > _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ > (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ > (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) >= _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) >= _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ >= (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ >= (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) << _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) << _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ << (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ << (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> (HOLE:Expr => reval(HOLE)) >> _ ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> (HOLE:Expr => reval(HOLE)) >> _ ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> _ >> (HOLE:Expr => reval(HOLE)) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> _ >> (HOLE:Expr => reval(HOLE)) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

     context <k> IfStmt((HOLE:Expr => reval(HOLE)), _, _) ...</k> 
             <compile-time-evaluation> true </compile-time-evaluation> [result(PRV)]
     context <k> IfStmt((HOLE:Expr => reval(HOLE)), _, _) ...</k>
             <compile-time-evaluation> false </compile-time-evaluation> [result(PRVal)]

endmodule
