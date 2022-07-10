port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0, clipboardMessage = "", errorMessage = "", textFile = "" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ gotTextFile GotTextFile, clipboardMessageReceiver GotClipboardMessage, gotErrorMessage GotErrorMessage ]


type alias Model =
    { counter : Int, clipboardMessage : String, errorMessage : String, textFile : String }


port setClipboard : String -> Cmd msg


port readTextFile : String -> Cmd msg


port clipboardMessageReceiver : (String -> msg) -> Sub msg


port gotTextFile : (String -> msg) -> Sub msg


port gotErrorMessage : (String -> msg) -> Sub msg


type Msg
    = Increment
    | Decrement
    | SetClipboard String
    | GotClipboardMessage String
    | GotErrorMessage String
    | ReadTextFile String
    | GotTextFile String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        SetClipboard string ->
            ( model, setClipboard string )

        GotClipboardMessage string ->
            ( { model | clipboardMessage = string }, Cmd.none )

        GotErrorMessage string ->
            ( { model | errorMessage = string }, Cmd.none )

        ReadTextFile string ->
            ( model, readTextFile string )

        GotTextFile string ->
            ( { model | textFile = string }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick (SetClipboard "Tauri is awesome!") ] [ text "Set clipboard" ]
        , button [ onClick (ReadTextFile "index.html") ] [ text "Read index.html" ]
        , div [] [ text model.clipboardMessage ]
        , div [] [ text model.errorMessage ]
        , div [] [ text model.textFile ]
        ]
