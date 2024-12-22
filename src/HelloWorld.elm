module HelloWorld exposing (main)

import Script exposing (Script)


script : Script.Init -> Script String ()
script {} =
    Script.printLine "Hello world"


main : Script.Program
main =
    Script.program script
