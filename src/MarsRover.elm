module MarsRover exposing (main)

import Parser exposing (parseGridSize, parseRobotInput)
import RobotLogic exposing (executeCommands, positionToString)
import Script exposing (Script, UserPrivileges)
import Script.Directory as Directory exposing (Directory)
import Script.Permissions as Permissions
import Types exposing (Robot)


readLine : UserPrivileges -> Directory Permissions.Writable -> Script String String
readLine userPrivileges workingDirectory =
    Script.executeWith userPrivileges
        { command = "sh"
        , arguments = ["-c", "read line && echo \"$line\""]
        , workingDirectory = workingDirectory
        }
        |> Script.map String.trim


readInput : UserPrivileges -> Directory Permissions.Writable -> List String -> Script String ()
readInput userPrivileges workingDirectory lines =
    readLine userPrivileges workingDirectory
        |> Script.thenWith
            (\line ->
                if String.isEmpty line then
                    if List.isEmpty lines then
                        Script.printLine "Please provide grid size and robot instructions"
                    else
                        processInput (String.join "\n" (List.reverse lines))
                else
                    readInput userPrivileges workingDirectory (line :: lines)
            )


script : Script.Init -> Script String ()
script { arguments, userPrivileges, workingDirectory } =
    case arguments of
        [] ->
            readInput userPrivileges workingDirectory []

        [input] ->
            processInput input

        gridSizeStr :: robotInputs ->
            processInput (String.join "\n" (gridSizeStr :: robotInputs))


processInput : String -> Script x ()
processInput input =
    case input |> String.replace "\\n" "\n" |> String.lines of
        gridSizeStr :: robotInputs ->
            case parseGridSize gridSizeStr of
                Ok grid ->
                    let
                        robotResults =
                            List.map parseRobotInput robotInputs

                        errors =
                            List.filterMap
                                (\result ->
                                    case result of
                                        Err msg ->
                                            Just msg

                                        Ok _ ->
                                            Nothing
                                )
                                robotResults

                        robots =
                            List.filterMap
                                (\result ->
                                    case result of
                                        Ok robot ->
                                            Just robot

                                        Err _ ->
                                            Nothing
                                )
                                robotResults
                    in
                    if not (List.isEmpty errors) then
                        Script.printLine (String.join "\n" errors)

                    else
                        let
                            finalPositions =
                                List.map (executeCommands grid) robots

                            output =
                                String.join "\n" (List.map positionToString finalPositions)
                        in
                        Script.printLine output

                Err msg ->
                    Script.printLine msg

        [] ->
            Script.printLine "Please provide grid size and robot instructions"


main : Script.Program
main =
    Script.program script
