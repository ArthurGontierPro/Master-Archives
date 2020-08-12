(*recherche de l'opérateur de l'expression*)
match op.id with
  [...]
  | PRE -> smtlib_of_pre left_var exprl [...]
  [...]

(*renvoie l'implication en smt qui traduit l'opérateur pre*)
let smtlib_of_pre state_paraml left_var node_name exprl node =
  (*récupère la variable X dans l'expression pre(X)*)
  let a = match (abstract_exprl_of_val_expl exprl) with a::[] -> a | _ -> failwith "pre with more than one arg" in

  (*récupère le prédicat de X si c'est une variable locale ou de sortie. Si c'est une variable d'entrée, ce sera la liste vide*)
  let left_pre = smtlib_of_implies_left_param a node_name state_paraml node in

  (*construit l'implication let_var = pre(X);*)
  F_implies(
    (*si X n'est pas une entrée, on intègre le prédicat précédement calculé à gauche de l'implication*)
    (match left_pre with 
      | [] -> F_bformula(Fe_binary(Fe_gt,time_var,Fe_int( zero : int64)))
      | _ -> F_and(F_bformula(Fe_binary(Fe_gt,time_var,Fe_int( zero : int64)))::left_pre))

    (*la formule à droite de l'implication correspondant à pre(X)*)
  ,F_bformula(Fe_call_state(node_name,get_smtvar_name left_var,(smtlib_of_introduce_expr state_paraml left_var (Fe_store(left_var,time_var,Fe_select(a,Fe_binary(Fe_sub,time_var,Fe_int( one : int64))))) false))))::[]

