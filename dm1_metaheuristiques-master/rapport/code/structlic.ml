type op =
  (*opérateurs classiques : +,-,*,/,...*)
  | PREDEF_CALL of node_key srcflagged
  (*appel de fonction ou d'itérateur*)
  | CALL of node_key srcflagged
  (*affectation de constante*)
  | CONST of const
  (*affectation de variable*)
  | VAR_REF of Lv6Id.t
  (*opérateur pre*)
  | PRE
  (*opérateur followed by*)
  | ARROW
  (*accès a un élément d'un tableau*)
  | ARRAY_ACCES of int

