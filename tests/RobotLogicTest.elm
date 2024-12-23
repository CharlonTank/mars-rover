module RobotLogicTest exposing (suite)

import Expect
import RobotLogic exposing (executeCommands, positionToString)
import Test exposing (Test, describe, test)
import Types exposing (Command(..), Direction(..), Grid)


suite : Test
suite =
    describe "RobotLogic"
        [ describe "executeCommands"
            [ test "executes commands without getting lost" <|
                \_ ->
                    let
                        grid =
                            Grid 4 8

                        robot =
                            { position =
                                { x = 2
                                , y = 3
                                , direction = North
                                , isLost = False
                                }
                            , commands = [ Forward, Forward, Left, Right ]
                            }
                    in
                    executeCommands grid robot
                        |> Expect.equal
                            { x = 2
                            , y = 5
                            , direction = North
                            , isLost = False
                            }
            , test "marks robot as lost when moving out of grid" <|
                \_ ->
                    let
                        grid =
                            Grid 4 8

                        robot =
                            { position =
                                { x = 4
                                , y = 4
                                , direction = East
                                , isLost = False
                                }
                            , commands = [ Forward ]
                            }
                    in
                    executeCommands grid robot
                        |> Expect.equal
                            { x = 4
                            , y = 4
                            , direction = East
                            , isLost = True
                            }
            , test "stops executing commands after getting lost" <|
                \_ ->
                    let
                        grid =
                            Grid 4 8

                        robot =
                            { position =
                                { x = 4
                                , y = 4
                                , direction = East
                                , isLost = False
                                }
                            , commands = [ Forward, Left, Forward ]
                            }
                    in
                    executeCommands grid robot
                        |> Expect.equal
                            { x = 4
                            , y = 4
                            , direction = East
                            , isLost = True
                            }
            , test "handles all directions correctly" <|
                \_ ->
                    let
                        grid =
                            Grid 4 8

                        robot =
                            { position =
                                { x = 2
                                , y = 3
                                , direction = North
                                , isLost = False
                                }
                            , commands = [ Forward, Right, Forward, Right, Forward, Right, Forward ]
                            }
                    in
                    executeCommands grid robot
                        |> Expect.equal
                            { x = 2
                            , y = 3
                            , direction = West
                            , isLost = False
                            }
            ]
        , describe "positionToString"
            [ test "formats normal position" <|
                \_ ->
                    let
                        position =
                            { x = 2
                            , y = 3
                            , direction = North
                            , isLost = False
                            }
                    in
                    positionToString position
                        |> Expect.equal "(2, 3, N)"
            , test "formats lost position" <|
                \_ ->
                    let
                        position =
                            { x = 4
                            , y = 4
                            , direction = East
                            , isLost = True
                            }
                    in
                    positionToString position
                        |> Expect.equal "(4, 4, E) LOST"
            ]
        ] 