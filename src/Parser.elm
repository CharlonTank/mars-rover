module Parser exposing
    ( parseCommand
    , parseCommands
    , parseDirection
    , parseGridSize
    , parseInitialPosition
    , parseRobotInput
    )

import Types exposing (Command(..), Direction(..), Grid, Position, Robot)


parseDirection : String -> Result String Direction
parseDirection str =
    case str of
        "N" ->
            Ok North

        "E" ->
            Ok East

        "S" ->
            Ok South

        "W" ->
            Ok West

        _ ->
            Err ("Invalid direction '" ++ str ++ "'. Expected: N, E, S, or W")


parseCommand : Char -> Result String Command
parseCommand char =
    case char of
        'F' ->
            Ok Forward

        'L' ->
            Ok Left

        'R' ->
            Ok Right

        _ ->
            Err ("Invalid command '" ++ String.fromChar char ++ "'. Expected: F, L, or R")


parseCommands : String -> Result String (List Command)
parseCommands str =
    let
        results =
            String.toList str
                |> List.map parseCommand

        errors =
            List.filterMap
                (\result ->
                    case result of
                        Err msg ->
                            Just msg

                        Ok _ ->
                            Nothing
                )
                results
    in
    if List.isEmpty errors then
        Ok (List.filterMap Result.toMaybe results)

    else
        Err (String.join "\n" errors)


parseGridSize : String -> Result String Grid
parseGridSize input =
    case String.split " " (String.trim input) of
        [ width, height ] ->
            case String.toInt width of
                Nothing ->
                    Err ("Invalid width '" ++ width ++ "'. Expected: integer")

                Just widthVal ->
                    case String.toInt height of
                        Nothing ->
                            Err ("Invalid height '" ++ height ++ "'. Expected: integer")

                        Just heightVal ->
                            if widthVal < 0 then
                                Err ("Width cannot be negative: " ++ width)

                            else if heightVal < 0 then
                                Err ("Height cannot be negative: " ++ height)

                            else
                                Ok (Grid widthVal heightVal)

        _ ->
            Err ("Invalid grid size format: '" ++ input ++ "'. Expected: width height")


parseInitialPosition : String -> Result String Position
parseInitialPosition input =
    if not (String.startsWith "(" input && String.contains ")" input) then
        Err "Invalid position format. Expected: x, y, D where x and y are integers and D is N, E, S, or W"

    else
        let
            cleanInput =
                input
                    |> String.replace "(" ""
                    |> String.replace ")" ""
                    |> String.trim
        in
        case String.split ", " cleanInput of
            [ x, y, dir ] ->
                case String.toInt x of
                    Nothing ->
                        Err ("Invalid x coordinate '" ++ x ++ "'. Expected: integer")

                    Just xVal ->
                        case String.toInt y of
                            Nothing ->
                                Err ("Invalid y coordinate '" ++ y ++ "'. Expected: integer")

                            Just yVal ->
                                parseDirection dir
                                    |> Result.map
                                        (\direction ->
                                            { x = xVal
                                            , y = yVal
                                            , direction = direction
                                            , isLost = False
                                            }
                                        )

            _ ->
                Err "Invalid position format. Expected: x, y, D where x and y are integers and D is N, E, S, or W"


parseRobotInput : String -> Result String Robot
parseRobotInput input =
    case String.split ")" input of
        [ posStr, cmdStr ] ->
            parseInitialPosition (posStr ++ ")")
                |> Result.andThen
                    (\position ->
                        let
                            trimmedCmd =
                                String.trim cmdStr
                        in
                        if String.isEmpty trimmedCmd then
                            Err ("Invalid robot input format: " ++ input ++ ". Expected format: (x, y, D) COMMANDS")

                        else
                            parseCommands trimmedCmd
                                |> Result.andThen
                                    (\cmds ->
                                        if List.isEmpty cmds then
                                            Err ("No valid commands found in: " ++ input ++ ". Expected commands: F, L, or R")

                                        else
                                            Ok (Robot position cmds)
                                    )
                    )

        _ ->
            Err ("Invalid robot input format: " ++ input ++ ". Expected format: (x, y, D) COMMANDS")
