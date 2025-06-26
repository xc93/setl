module SETL-SYNTAX
  imports DOMAINS-SYNTAX
  
  syntax Address ::= r"0x[0-9a-f]{40}" [token]
  
  syntax BasicValue ::= Address | Bool | Int | String
         
  syntax BasicValueList ::= List{BasicValue, ","}
  
  syntax Value ::= BasicValue
                 | "[" BasicValueList "]"
                 | "{" BasicValueList "}" 
         
  syntax IdOrAddress ::= Id | Address
  
  syntax IdList ::= List{Id, ","}
  
  syntax AddressList ::= List{Address, ","}
  
  syntax Type ::= BasicType 
                | "List" 
                | "Set"
                | BasicType "->" BasicType
   
  syntax BasicType ::= "Address"
                     | "Bool"
                     | "Int"
                     | "String"
                     | "Bytes"
         
  syntax Expr ::= BasicExpr
                | ListExpr
                | SetExpr
  
  syntax BasicExpr ::= Id
                     | Address
                     | Int
                     | String
                     | "time"
                     | "instance" "." "owner"
                     | "contract" "." "owner"
                     | Id "." Id
                     | Id "[" Expr "]"
                     | BasicExpr BinOp BasicExpr
  
  syntax BasicExprList ::= List{BasicExpr, ","}
  
  syntax BinOp ::= "+" | "-" | "*" | "/"
         
  syntax ListExpr ::= Id | "[" BasicExprList "]"
  
  syntax SetExpr ::= Id | "{" BasicExprList "}"
  
  syntax InContractClaim ::= CondClaim
                           | "apply" "(" BasicExpr ")" ";"
                           | "transfer" "(" BasicExpr "," BasicExpr ")" ";"
                           | "verify" "(" SetExpr "," BasicExpr ")" ";"
                           | "claim" "(" BasicExprList ")" ";"
                           | IdOrAddress "." Id "(" BasicExprList ")" ";"
                           | IdOrAddress "." "add" "(" BasicExpr ")" ";"
                           | IdOrAddress "." "sub" "(" BasicExpr ")" ";"
                           | IdOrAddress "." "next" "(" BasicExpr ")" ";"
                           | AssignLeftExpr ":=" Expr ";"
                           | AssignLeftExpr "+=" Expr ";"
                           | AssignLeftExpr "-=" Expr ";"

  syntax InContractClaimList ::= List{InContractClaim, ""}
  
  syntax AssignLeftExpr ::= Id | Id "[" BasicExpr "]"
  
  syntax CondClaim ::= CondExpr ";"
  
  syntax CondExpr ::= "true"
                    | "false"
                    | "isSettled" "(" IdOrAddress ")"
                    | "isSettled" "(" "claim" "(" BasicExprList ")" ")"
                    | Id
                    | BasicExpr BinRel BasicExpr
                    | CondExpr "and" CondExpr
                    | CondExpr "or" CondExpr
                    | "not" CondExpr
                    | "(" CondExpr ")" [bracket]
                    
  syntax BinRel ::= ">" | ">=" | "<" | "<=" | "==" | "!=" | "in"
  
  syntax ContractCreationClaim ::= "contract" "(" FieldOrBlockDeclList ")" ";"
                                 | "contract" "(" Address ")" ";"
                                 | "contract" "(" Address "[" BasicValueList "]" ")" ";"
  
  syntax InstanceCreationClaim ::= "instance" "(" Address ")" ";"
  
  syntax TemplateCreationClaim ::= "template" "(" "[" IdList "]" String ")" ";"
  
  syntax FieldOrBlockDecl ::= FieldDecl | BlockDecl
  
  syntax FieldOrBlockDeclList ::= List{FieldOrBlockDecl, ""}
  
  syntax FieldDecl ::= Id ":" Type ";"
                     | "instance" Id ":" Type ";"
                     
  syntax BlockDecl ::= Id "(" IdList ")" "{" InContractClaimList "}"
                     | "instance" Id "(" IdList ")" "{" InContractClaimList "}"
                     | "constructor" "{" InitStmtList "}"
                     | "instance" "constructor" "{" InitStmtList "}"
  
  syntax InitStmtList ::= List{InitStmt, ""}
  
  syntax InitStmt ::= Id ":=" Value ";"
  
  syntax TopLevelBlock ::= InContractClaimList
                         | ContractCreationClaim
                         | InstanceCreationClaim
                         | TemplateCreationClaim
endmodule

module SETL
  imports DOMAINS
  imports SETL-SYNTAX
  
  configuration <k> $PGM:TopLevelBlock </k>
  
  syntax KResult ::= Value
  
endmodule
