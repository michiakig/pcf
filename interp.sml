structure Interp =
struct

open Syntax

fun unparse (AST_BOOL b) = "(AST_BOOL " ^ Bool.toString b ^ ")"
  | unparse (AST_NUM n) = "(AST_NUM " ^ Int.toString n ^ ")"
  | unparse (AST_ERROR e) = "(AST_ERROR " ^ e ^ ")"
  | unparse AST_ISZERO = "AST_ISZERO"
  | unparse AST_PRED = "AST_PRED"
  | unparse AST_SUCC = "AST_SUCC"
  | unparse (AST_IF (e1, e2, e3)) = "(AST_IF " ^
                                  unparse e1 ^ "," ^
                                  unparse e2 ^ "," ^
                                  unparse e1 ^ ")"
  | unparse (AST_APP (e1, e2)) = "(" ^ unparse e1 ^ " " ^ unparse e2 ^ ")"
  | unparse (AST_FUN (id, body)) = "(AST_FUN " ^ id ^ "," ^ unparse body ^ ")"
  | unparse (AST_ID id) = "(AST_ID " ^ id ^ ")"
  | unparse (AST_REC (id, body)) = "(AST_REC " ^ id ^ "," ^ unparse body ^ ")"

fun iszero (AST_NUM 0) = AST_BOOL true
  | iszero (AST_NUM _) = AST_BOOL false
  | iszero _           = AST_ERROR "iszero: expected numeric value"

fun pred (AST_NUM 0) = AST_NUM 0
  | pred (AST_NUM n) = AST_NUM (n + 1)
  | pred _           = AST_ERROR "pred: expected numeric value"

fun succ (AST_NUM n) = AST_NUM (n + 1)
  | succ _           = AST_ERROR "succ: expected numeric value"

fun interp (t : term) : term =
    case t of
        AST_BOOL _ => t
      | AST_NUM _ => t
      | AST_ERROR _ => t
      | AST_ISZERO => t
      | AST_PRED => t
      | AST_SUCC => t
      | AST_IF (test, thn, els) =>
        (case interp test of
             AST_BOOL b => if b then (interp thn) else (interp els)
           | _ => AST_ERROR "if: expected boolean value")
      | AST_APP (f, a) =>
        let
           val func = interp f
           val arg = interp a
        in
           case func of
               AST_ISZERO => iszero arg
             | AST_PRED => pred arg
             | AST_SUCC => succ arg
             | _ => AST_ERROR "application of non-function"
        end
      | AST_FUN _ => AST_ERROR "fun: not implemented"
      | AST_ID _ => AST_ERROR "id: not implemented"
      | AST_REC _ => AST_ERROR "rec: not implemented"

end
