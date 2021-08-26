module ParserTest exposing (..)

import Expect
import Language.Parser as Parser
import Test exposing (Test, describe, test)


suite : Test
suite =
    let
        goodProgram =
            """1
2
<
flip if
+

halt
"hello world"
print"""

        goodProgramParse =
            Ok <|
                [ Parser.AstLine 1 <| Parser.Int 1
                , Parser.AstLine 2 <| Parser.Int 2
                , Parser.AstLine 3 <| Parser.Id "<"
                , Parser.AstLine 4 <| Parser.Id "flip if"
                , Parser.AstLine 5 <| Parser.Id "+"
                , Parser.AstLine 7 <| Parser.Id "halt"
                , Parser.AstLine 8 <| Parser.Str "hello world"
                , Parser.AstLine 9 <| Parser.Id "print"
                ]

        badProgram =
            """1
2
"asdfasd
"""

        badProgramParse =
            Err <|
                [ Parser.ErrorLine 3 "failed to parse line" ]
    in
    describe "parse"
        [ test "good parse" <|
            \_ -> Expect.equal goodProgramParse <| Parser.parse goodProgram
        , test "bad parse" <|
            \_ -> Expect.equal badProgramParse <| Parser.parse badProgram
        ]
