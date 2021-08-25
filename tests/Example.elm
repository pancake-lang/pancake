module Example exposing (..)

import Expect
import Language.Parser as Parser
import Test exposing (Test, test)


suite : Test
suite =
    let
        goodProgram =
            """1
2
<
flip_if
+

halt"""

        goodProgramParse =
            Ok <|
                [ Parser.AstLine 1 <| Parser.Int 1
                , Parser.AstLine 2 <| Parser.Int 2
                , Parser.AstLine 3 <| Parser.Id "<"
                , Parser.AstLine 4 <| Parser.Id "flip_if"
                , Parser.AstLine 5 <| Parser.Id "+"
                , Parser.AstLine 7 <| Parser.Id "halt"
                ]
    in
    test "good parse"
        (\_ -> Expect.equal goodProgramParse <| Parser.parse goodProgram)
