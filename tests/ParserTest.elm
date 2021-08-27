module ParserTest exposing (..)

import Expect
import Language.Parser as Parser exposing (Citizen(..))
import Language.World exposing (World(..))
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
"hello world"       ; will be printed later
print
@label
# omega world   
# 42
# "hello there"  
@ end of the world
"""

        goodProgramParse =
            Ok <|
                [ Parser.AstLine 1 <| Citizen Alpha (Parser.Int 1) ""
                , Parser.AstLine 2 <| Citizen Alpha (Parser.Int 2) ""
                , Parser.AstLine 3 <| Citizen Alpha (Parser.Id "<") ""
                , Parser.AstLine 4 <| Citizen Alpha (Parser.Id "flip if") ""
                , Parser.AstLine 5 <| Citizen Alpha (Parser.Id "+") ""
                , Parser.AstLine 7 <| Citizen Alpha (Parser.Id "halt") ""
                , Parser.AstLine 8 <|
                    Citizen Alpha
                        (Parser.Str "hello world")
                        "; will be printed later"
                , Parser.AstLine 9 <| Citizen Alpha (Parser.Id "print") ""
                , Parser.AstLine 10 <| Label "label" ""
                , Parser.AstLine 11 <| Citizen Omega (Parser.Id "omega world") ""
                , Parser.AstLine 12 <| Citizen Omega (Parser.Int 42) ""
                , Parser.AstLine 13 <| Citizen Omega (Parser.Str "hello there") ""
                , Parser.AstLine 14 <| Label "end of the world" ""
                ]

        badProgram =
            """1
2
"asdfasd
hello 42
# "asdf
@ 42
# ; incomplete line
  ; alpha incomplete line
"""

        badProgramParse =
            Err <|
                [ Parser.ErrorLine 3 "failed to parse line"
                , Parser.ErrorLine 4 "failed to parse line"
                , Parser.ErrorLine 5 "failed to parse line"
                , Parser.ErrorLine 6 "failed to parse line"
                , Parser.ErrorLine 7 "failed to parse line"
                ]
    in
    describe "parse"
        [ test "good parse" <|
            \_ -> Expect.equal goodProgramParse <| Parser.parse goodProgram
        , test "bad parse" <|
            \_ -> Expect.equal badProgramParse <| Parser.parse badProgram
        ]
