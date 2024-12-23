module MarsRoverTest exposing (suite)

import Expect
import Parser exposing (parseGridSize, parseRobotInput)
import RobotLogic exposing (executeCommands)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "MarsRover Integration"
        [ test "example 1 - one robot gets lost" <|
            \_ ->
                let
                    input =
                        [ "4 8"
                        , "(2, 3, E) LFRFF"
                        , "(0, 2, N) FFLFRFF"
                        ]

                    expectedOutput =
                        [ "(4, 4, E)"
                        , "(0, 4, W) LOST"
                        ]
                in
                case parseGridSize (Maybe.withDefault "" (List.head input)) of
                    Ok grid ->
                        input
                            |> List.drop 1
                            |> List.map parseRobotInput
                            |> List.map (Result.map (executeCommands grid))
                            |> List.map (Result.map RobotLogic.positionToString)
                            |> List.map (Result.withDefault "Error")
                            |> Expect.equal expectedOutput

                    Err _ ->
                        Expect.fail "Failed to parse grid size"
        , test "example 2 - one robot gets lost at south border" <|
            \_ ->
                let
                    input =
                        [ "4 8"
                        , "(2, 3, N) FLLFR"
                        , "(1, 0, S) FFRLF"
                        ]

                    expectedOutput =
                        [ "(2, 3, W)"
                        , "(1, 0, S) LOST"
                        ]
                in
                case parseGridSize (Maybe.withDefault "" (List.head input)) of
                    Ok grid ->
                        input
                            |> List.drop 1
                            |> List.map parseRobotInput
                            |> List.map (Result.map (executeCommands grid))
                            |> List.map (Result.map RobotLogic.positionToString)
                            |> List.map (Result.withDefault "Error")
                            |> Expect.equal expectedOutput

                    Err _ ->
                        Expect.fail "Failed to parse grid size"
        ] 