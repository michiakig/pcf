structure InterpTests =
struct

open Interp

val tests =
    Test.concat [
       Test.group
          ("subst", Test.polyAssertEq {show = unparse},
           [{actual = subst (AST_APP (AST_SUCC,AST_ID "x"), "x", AST_NUM 1),
             expected = AST_APP (AST_SUCC,AST_NUM 1)},
            {actual = subst (AST_APP (AST_FUN ("x", AST_APP (AST_SUCC, AST_ID "x")),
                                      (AST_APP (AST_PRED, AST_ID "x"))),
                             "x", AST_NUM 3),
             expected = AST_APP (AST_FUN ("x", AST_APP (AST_SUCC, AST_ID "x")),
                                 (AST_APP (AST_PRED, AST_NUM 3)))}
          ]),
    Test.group
       ("interp", Test.polyAssertEq {show = unparse},
        [
         {actual = interp (AST_BOOL false), expected = AST_BOOL false},
         {actual = interp (AST_NUM 0), expected = AST_NUM 0},
         {actual = interp (AST_ERROR "error"), expected = AST_ERROR "error"},
         {actual = interp AST_PRED, expected = AST_PRED},
         {actual = interp AST_SUCC, expected = AST_SUCC},
         {actual = interp AST_ISZERO, expected = AST_ISZERO},
         {actual = interp (AST_IF (AST_BOOL false, AST_BOOL false, AST_BOOL true)),
          expected = AST_BOOL true},
         {actual = interp (AST_APP (AST_ISZERO, AST_NUM 0)),
          expected = AST_BOOL true},

         {actual = interp (AST_APP (AST_FUN ("x", AST_ID "x"), AST_NUM 0)),
          expected = AST_NUM 0}
       ])]

fun main _ = (Test.runTestSuite (true, tests); OS.Process.success)

end
