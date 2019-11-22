module Counter exposing (main)

{- This is a starter app which sets up a tick loop that
   performs an action once a second.  In this example,
   the action is to update a counter.

   Note the type signature:

      Time.every : Float -> (Posix -> msg) -> Sub msg

   This is why in Msg one has

      Tick Time.Posix


   even though the "current" time is not used in the app.

   The code here is adapted from the Time section of the Elm Guide:
   https://guide.elm-lang.org/effects/time.html
-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Task
import Time


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { counter : Int
    }


type Msg
    = NoOp
    | Tick Time.Posix


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { counter = 0 }, Cmd.none )


subscriptions model =
    Time.every 1000 Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick _ ->
            ( { model | counter = model.counter + 1 }, Cmd.none )



--
-- VIEW
--


view : Model -> Html Msg
view model =
    Element.layout [] (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    column mainColumnStyle
        [ column [ centerX, spacing 20 ]
            [ title "Counter"
            , display model
            ]
        ]


title : String -> Element msg
title str =
    row [ centerX, Font.bold ] [ text str ]


display : Model -> Element msg
display model =
    row [ centerX ]
        [ text <| String.fromInt model.counter ]



--
-- STYLE
--


mainColumnStyle =
    [ centerX
    , centerY
    , Background.color (rgb255 240 240 255)
    , Border.width 2
    , paddingXY 20 20
    ]
