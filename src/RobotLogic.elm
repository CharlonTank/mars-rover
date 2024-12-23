module RobotLogic exposing
    ( executeCommands
    , positionToString
    )

import Types exposing (Command(..), Direction(..), Grid, Position, Robot)


turnLeft : Direction -> Direction
turnLeft direction =
    case direction of
        North ->
            West

        East ->
            North

        South ->
            East

        West ->
            South


turnRight : Direction -> Direction
turnRight direction =
    case direction of
        North ->
            East

        East ->
            South

        South ->
            West

        West ->
            North


moveForward : Position -> Position
moveForward position =
    case position.direction of
        North ->
            { position | y = position.y + 1 }

        East ->
            { position | x = position.x + 1 }

        South ->
            { position | y = position.y - 1 }

        West ->
            { position | x = position.x - 1 }


isValidPosition : Grid -> Position -> Bool
isValidPosition grid position =
    position.x
        >= 0
        && position.x
        < grid.width
        + 1
        && position.y
        >= 0
        && position.y
        < grid.height
        + 1


executeCommand : Grid -> Command -> Position -> Position
executeCommand grid command position =
    if position.isLost then
        position

    else
        case command of
            Left ->
                { position | direction = turnLeft position.direction }

            Right ->
                { position | direction = turnRight position.direction }

            Forward ->
                let
                    newPosition =
                        moveForward position
                in
                if isValidPosition grid newPosition then
                    newPosition

                else
                    { position | isLost = True }


executeCommands : Grid -> Robot -> Position
executeCommands grid robot =
    List.foldl (executeCommand grid) robot.position robot.commands


directionToString : Direction -> String
directionToString direction =
    case direction of
        North ->
            "N"

        East ->
            "E"

        South ->
            "S"

        West ->
            "W"


positionToString : Position -> String
positionToString pos =
    "("
        ++ String.fromInt pos.x
        ++ ", "
        ++ String.fromInt pos.y
        ++ ", "
        ++ directionToString pos.direction
        ++ ")"
        ++ (if pos.isLost then
                " LOST"

            else
                ""
           )
