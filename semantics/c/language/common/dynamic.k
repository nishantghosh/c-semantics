// information used by execution and translation configuration and therefore
// included in all C and C++ modules
module C-DYNAMIC-SORTS
     imports COMMON-SORTS
     syntax LHold
     syntax RHold
     syntax NCLHold
     syntax RValue
     syntax LValue
     syntax Nclv
     syntax Hold
     syntax Scope
     syntax TrapLValue
     syntax Agg
     syntax Typed ::= LValue | RValue | Hold | Nclv | TrapLValue
     syntax HoldResult ::= NCLHold | RHold
     syntax HoldLValue ::= NCLHold | LHold
endmodule

module C-REVAL-SYNTAX
     imports BASIC-K
     syntax KItem ::= reval(K)
endmodule

module C-DYNAMIC-SYNTAX
     imports BASIC-K
     imports FLOAT-SYNTAX
     imports INT-SYNTAX 
     imports K-REFLECTION
     imports LIST
     imports BITS-SORTS
     imports C-DYNAMIC-SORTS
     imports C-REVAL-SYNTAX
     imports C-TYPING-SORTS
     imports SYMLOC-SORTS

     syntax Agg ::= agg(List)

     syntax LValue ::= lv(SymLoc, Type)

     // These hold typed frozen computations -- one each for lvalues, rvalues,
     // and non-converted lvalues.
     syntax LHold ::= le(K, Type)
     syntax RHold ::= te(K, UType)
     syntax NCLHold ::= ncle(K, Type)
     syntax CompoundExpression ::= compoundExp(K)
     syntax Hold ::= HoldLValue | HoldResult | CompoundExpression

     syntax K ::= stripHold(K) [function]

     syntax RValue ::= "voidVal" [klabel(voidVal)]
     syntax RValue ::= "emptyValue"
     syntax RValue ::= tv(CValue, UType)
          [latex(renameTo \\ensuremath{{_}\\mathop{:}{_}})]

     syntax KItem ::= toRVal(K)

     syntax Typed ::= Type

     syntax Valued ::= LValue | RValue | Hold
     syntax K ::= value(K) [function]

     syntax KItem ::= "discard"

     syntax Nclv ::= nclv(SymLoc, Type)
     syntax TrapLValue ::= trap(UType) [klabel(trap1)]
     syntax LValue ::= Nclv | HoldLValue | TrapLValue
     syntax KResult ::= RValue | Type | UType | DType | Nclv | TrapLValue

     syntax BlockScope ::= blockScope(functionId: CId, functionLoc: SymBase, block: Int)
     syntax PrototypeScope ::= "prototypeScope"
     syntax Scope ::= PrototypeScope | BlockScope

     //  switchid, caseid, value (tv or 'Default)
     syntax CId ::= caseLabel(Int, K)
     syntax CId ::= "funLabel"

     syntax CId ::= nativeFunction(Int)

     syntax KItem ::= pushBlock(Int) [klabel(pushBlock_C-DYNAMIC-SYNTAX)]
     syntax KItem ::= "popBlock"

     syntax Statement ::= "loopMarked"
     syntax KItem ::= "popLoop"

     //  nesting-depth, currentBlock, decl
     syntax KItem ::= frozenDeclaration(Int, K)
     //  block history, continuation, loop stack, decl stack
     syntax GotoObject ::= gotoObject(List, K, List, List)
          [latex(\terminal{gotoObj}\!({#1},{#2},{#3},{#4},{#5}\!))]

     syntax KItem ::= "comma"
     // these are semantic

     syntax KResult ::= initValue(CId, Type, K)
     syntax NoInit
     syntax KResult ::= NoInit

     syntax CompoundLiteralId ::= compoundLiteral(Int)
     syntax CId ::= CompoundLiteralId

     syntax KItem ::= typedef(CId, Type)
     syntax KItem ::= declareInternalVariable(CId, K, K) [strict(2,3)]

     //TODO(liyili2): might not need this list in the future.
     syntax HeatItem ::= hItem(K)
     context hItem(HOLE:KItem => reval(HOLE)) [ndheat, result(RValue)]
     syntax HeatList ::= List{HeatItem,"hs::"} [strict]
     syntax KItem ::= hlist(HeatList) [strict]
     syntax HeatList ::= toHeatList(List) [function]
     syntax List ::= hListToList(HeatList) [function]

     syntax Bool ::= allRValueInHeatList(HeatList) [function]

     syntax HeatResult ::= hrItem(RValue)
     syntax HeatItem ::= HeatResult
     syntax KResult ::= HeatResult

     rule hItem(V:RValue) => hrItem(V)

     rule toHeatList(.List) => .HeatList
     rule toHeatList(ListItem(K:KItem) L:List) => hItem(K) hs:: toHeatList(L)

     rule hListToList(.HeatList) => .List
     rule hListToList(hrItem(V:RValue) hs:: HL:HeatList) => ListItem(V) hListToList(HL)

     syntax KItem ::= "LHOLE" | "RHOLE"
     syntax KItem ::= postOp(K, K) [strict(1)]
     syntax KItem ::= compoundAssign(K, K) [strict(1)]
     syntax KItem ::= fillLHoles(K, K) [function]
     syntax KItem ::= fillRHoles(RValue, K) [function]

     syntax KItem ::= "checkStackDepth"

     // Initializers.
     syntax InitLValue ::= LValue
                         | InitLValue "[" "[" Int "]" "]" [strict(1)]
                         | InitLValue ".init" CId [strict(1)]

     syntax EncodableValue ::= Opaque
     syntax Opaque ::= opaque(K, UType)
     syntax K ::= fromOpaque(CValue) [function]

     syntax KItem ::= "defaultCase"

endmodule

module C-DYNAMIC
     imports C-DYNAMIC-SYNTAX
     imports BOOL
     imports K-EQUAL
     imports C-CHECK-USE-SYNTAX
     imports C-SETTINGS-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-SYNTAX

     rule isKResult(.HeatList) => true
     rule isKResult(S1::HeatItem hs:: S2::HeatList) => isKResult(S1) andBool isKResult(S2)

     context toRVal(HOLE:KItem => reval(HOLE)) [result(RValue)]

     rule stripHold(te(K:K, _)) => K
     rule stripHold(le(K:K, _)) => K
     rule stripHold(ncle(K:K, _)) => K
     rule stripHold(tv(_, _) #as V::RValue) => checkUse(V)
     rule stripHold(nclv(Loc::SymLoc, T::Type)) => lv(Loc, T)
     rule stripHold(K:K) => K [owise]

     rule value(tv(V:CValue, _)) => V
     rule value(nclv(Loc:SymLoc, _)) => Loc
     rule value(te(K:K, _)) => K
     rule value(le(K:K, _)) => K
     rule value(ncle(K:K, _)) => K
     rule value(compoundExp(K:K)) => K

     rule type(tv(_, T::UType)) => type(T)
     rule type(voidVal) => type(void)
     rule type(lv(_, T::Type)) => T
     rule type(nclv(_, T::Type)) => T
     rule type(te(_, T::UType)) => type(T)
     rule type(le(_, T::Type)) => T
     rule type(ncle(_, T::Type)) => T
     rule type(trap(T::UType)) => type(T)

     rule utype(tv(_, T::UType)) => T
     rule utype(voidVal) => utype(void)
     rule utype(lv(_, T::Type)) => utype(T)
     rule utype(nclv(_, T::Type)) => utype(T)
     rule utype(te(_, T:UType)) => T
     rule utype(le(_, T::Type)) => utype(T)
     rule utype(ncle(_, T::Type)) => utype(T)
     rule utype(trap(T::UType)) => T

     rule _:KResult ~> discard => .K
          [structural]

     rule discard => .K
          [structural]

     rule N:Int => tv(N, utype(cfg:largestUnsigned))
          [structural] // for internal computations

     rule isNoInit(NoInit()) => true
     rule isNoInit(initValue(_, _, .K)) => true
     rule isNoInit(_) => false [owise]

     rule fillRHoles(V:RValue, te(L:K := E:K, T::UType)) => te(L := fillRHoles(V, E), T)
     rule fillRHoles(V:RValue, Cast(T::Type, E:K)) => Cast(T, fillRHoles(V, E))
     rule fillRHoles(V:RValue, RHOLE) => V
     rule fillRHoles(V:RValue, L:K * R:K) => fillRHoles(V, L) * R
     rule fillRHoles(V:RValue, L:K / R:K) => fillRHoles(V, L) / R
     rule fillRHoles(V:RValue, L:K % R:K) => fillRHoles(V, L) % R
     rule fillRHoles(V:RValue, L:K + R:K) => fillRHoles(V, L) + R
     rule fillRHoles(V:RValue, L:K - R:K) => fillRHoles(V, L) - R
     rule fillRHoles(V:RValue, L:K << R:K) => fillRHoles(V, L) << R
     rule fillRHoles(V:RValue, L:K >> R:K) => fillRHoles(V, L) >> R
     rule fillRHoles(V:RValue, L:K & R:K) => fillRHoles(V, L) & R
     rule fillRHoles(V:RValue, L:K ^ R:K) => fillRHoles(V, L) ^ R
     rule fillRHoles(V:RValue, L:K | R:K) => fillRHoles(V, L) | R

     rule fillLHoles(LV:K, te(LHOLE := R:K, T::UType))
          => te(LV := R, T)

     rule allRValueInHeatList(.HeatList) => true
     rule allRValueInHeatList(hItem(_) hs:: _) => false
     rule allRValueInHeatList(hrItem(_) hs:: HL:HeatList)
          => allRValueInHeatList(HL)

     rule fromOpaque(opaque(V:K, _)) => V
     rule fromOpaque(_) => .K [owise]

endmodule
