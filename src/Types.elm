module Types exposing
    ( Command(..)
    , Direction(..)
    , Grid
    , Position
    , Robot
    )


type Direction
    = North
    | East
    | South
    | West


type Command
    = Forward
    | Left
    | Right


type alias Position =
    { x : Int
    , y : Int
    , direction : Direction
    , isLost : Bool
    }


type alias Grid =
    { width : Int
    , height : Int
    }


type alias Robot =
    { position : Position
    , commands : List Command
    }
