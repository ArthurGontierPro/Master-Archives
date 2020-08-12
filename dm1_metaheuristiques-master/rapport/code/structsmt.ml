type abstract_expr =
  (*variable*)
  | Fe_variable of abstract_var
  (*opérateurs unaires et binaires*)
  | Fe_unary of fe_unary_op * abstract_expr
  | Fe_binary of fe_binary_op * abstract_expr * abstract_expr
  (*les opérateurs sur tableaux*)
  | Fe_select of abstract_expr * abstract_expr
  | Fe_store of abstract_expr * abstract_expr * abstract_expr
        
type formula =
  (*implication de deux formule*)
  | F_implies of formula*formula
  (*conjonction de formules*)
  | F_and of formula list
  (*formule booléenne*)
  | F_bformula of abstract_expr

