module ParserTest exposing (suite)

import Expect
import Parser exposing (parseCommand, parseCommands, parseDirection, parseGridSize, parseInitialPosition, parseRobotInput)
import Test exposing (Test, describe, test)
import Types exposing (Command(..), Direction(..), Grid, Position, Robot)


suite : Test
suite =
    describe "Parser"
        [ describe "parseDirection"
            ([ ( "N", North )
             , ( "E", East )
             , ( "S", South )
             , ( "W", West )
             ]
                |> List.map
                    (\( input, expected ) ->
                        test ("parses " ++ input) <|
                            \_ ->
                                parseDirection input
                                    |> Expect.equal (Ok expected)
                    )
                |> List.append
                    [ test "returns error for invalid direction" <|
                        \_ ->
                            parseDirection "X"
                                |> Expect.equal (Err "Invalid direction 'X'. Expected: N, E, S, or W")
                    ]
            )
        , describe "parseCommand"
            ([ ( 'F', Forward )
             , ( 'L', Left )
             , ( 'R', Right )
             ]
                |> List.map
                    (\( input, expected ) ->
                        test ("parses " ++ String.fromChar input) <|
                            \_ ->
                                parseCommand input
                                    |> Expect.equal (Ok expected)
                    )
                |> List.append
                    [ test "returns error for invalid command" <|
                        \_ ->
                            parseCommand 'X'
                                |> Expect.equal (Err "Invalid command 'X'. Expected: F, L, or R")
                    ]
            )
        , describe "parseCommands"
            [ test "parses sequence of valid commands" <|
                \_ ->
                    parseCommands "FFLR"
                        |> Expect.equal (Ok [ Forward, Forward, Left, Right ])
            , test "returns error for invalid commands" <|
                \_ ->
                    parseCommands "FXLR"
                        |> Expect.equal (Err "Invalid command 'X'. Expected: F, L, or R")
            , test "handles empty string" <|
                \_ ->
                    parseCommands ""
                        |> Expect.equal (Ok [])
            ]
        , describe "parseGridSize"
            [ test "parses valid grid size" <|
                \_ ->
                    parseGridSize "4 8"
                        |> Expect.equal (Ok (Grid 4 8))
            , test "returns error for invalid width" <|
                \_ ->
                    parseGridSize "x 8"
                        |> Expect.equal (Err "Invalid width 'x'. Expected: integer")
            , test "returns error for invalid height" <|
                \_ ->
                    parseGridSize "4 y"
                        |> Expect.equal (Err "Invalid height 'y'. Expected: integer")
            , test "returns error for negative width" <|
                \_ ->
                    parseGridSize "-4 8"
                        |> Expect.equal (Err "Width cannot be negative: -4")
            , test "returns error for negative height" <|
                \_ ->
                    parseGridSize "4 -8"
                        |> Expect.equal (Err "Height cannot be negative: -8")
            , test "returns error for invalid format" <|
                \_ ->
                    parseGridSize "4,8"
                        |> Expect.equal (Err "Invalid grid size format: '4,8'. Expected: width height")
            ]
        , describe "parseInitialPosition"
            [ test "parses valid position" <|
                \_ ->
                    parseInitialPosition "(2, 3, N)"
                        |> Expect.equal
                            (Ok
                                { x = 2
                                , y = 3
                                , direction = North
                                , isLost = False
                                }
                            )
            , test "returns error for invalid x coordinate" <|
                \_ ->
                    parseInitialPosition "(x, 3, N)"
                        |> Expect.equal (Err "Invalid x coordinate 'x'. Expected: integer")
            , test "returns error for invalid y coordinate" <|
                \_ ->
                    parseInitialPosition "(2, y, N)"
                        |> Expect.equal (Err "Invalid y coordinate 'y'. Expected: integer")
            , test "returns error for invalid direction" <|
                \_ ->
                    parseInitialPosition "(2, 3, X)"
                        |> Expect.equal (Err "Invalid direction 'X'. Expected: N, E, S, or W")
            , test "returns error for invalid format" <|
                \_ ->
                    parseInitialPosition "2, 3, N"
                        |> Expect.equal (Err "Invalid position format. Expected: x, y, D where x and y are integers and D is N, E, S, or W")
            ]
        , describe "parseRobotInput"
            [ test "parses valid robot input" <|
                \_ ->
                    parseRobotInput "(2, 3, N) FFLR"
                        |> Expect.equal
                            (Ok
                                { position =
                                    { x = 2
                                    , y = 3
                                    , direction = North
                                    , isLost = False
                                    }
                                , commands = [ Forward, Forward, Left, Right ]
                                }
                            )
            , test "returns error for invalid position" <|
                \_ ->
                    parseRobotInput "(x, 3, N) FFLR"
                        |> Expect.equal (Err "Invalid x coordinate 'x'. Expected: integer")
            , test "returns error for invalid commands" <|
                \_ ->
                    parseRobotInput "(2, 3, N) FFXLR"
                        |> Expect.equal (Err "Invalid command 'X'. Expected: F, L, or R")
            , test "returns error for empty commands" <|
                \_ ->
                    parseRobotInput "(2, 3, N)"
                        |> Expect.equal (Err "Invalid robot input format: (2, 3, N). Expected format: (x, y, D) COMMANDS")
            ]
        ] 