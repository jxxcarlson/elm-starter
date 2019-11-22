module Clock exposing (main)

{- This is a starter app which sets up a tick loop that
   performs an action once a second.  In this example,
   the action is to update a display with the current time.

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
    { zone : Time.Zone
    , time : Time.Posix
    }


type Msg
    = NoOp
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { zone = Time.utc
      , time = Time.millisToPosix 0
      }
    , Task.perform AdjustTimeZone Time.here
    )


subscriptions model =
    Time.every 1000 Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )



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
            [ title "Time"
            , display model
            ]
        ]


title : String -> Element msg
title str =
    row [ centerX, Font.bold ] [ text str ]


display : Model -> Element msg
display model =
    row [ centerX ]
        [ text <| humanTime model.zone model.time ]



--
-- HELPERS
--


humanTime : Time.Zone -> Time.Posix -> String
humanTime zone time =
    let
        hour =
            String.fromInt (Time.toHour zone time)

        minute =
            String.fromInt (Time.toMinute zone time)
                |> String.padLeft 2 '0'

        second =
            String.fromInt (Time.toSecond zone time)
                |> String.padLeft 2 '0'
    in
    hour ++ ":" ++ minute ++ ":" ++ second



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
