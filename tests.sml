structure InterpTests =
struct

open Interp

val tests = Test.single ("succ", Test.polyAssertEq {show = unparse},
                         {actual = interp (AST_NUM 0), expected = AST_NUM 0})

fun main _ = (Test.runTestSuite (true, tests); OS.Process.success)

end
