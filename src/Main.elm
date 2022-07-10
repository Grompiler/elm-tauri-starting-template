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
    ( { counter = 0, clipboardMessage = "" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    clipboardMessageReceiver GotClipboardMessage


type alias Model =
    { counter : Int, clipboardMessage : String }


port sendStringToTauriApp : String -> Cmd msg


port setClipboard : String -> Cmd msg


port clipboardMessageReceiver : (String -> msg) -> Sub msg


type Msg
    = Increment
    | Decrement
    | SendString String
    | SetClipboard String
    | GotClipboardMessage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        SendString string ->
            ( model, sendStringToTauriApp string )

        SetClipboard string ->
            ( model, setClipboard string )

        GotClipboardMessage string ->
            ( { model | clipboardMessage = string }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick (SendString "Hello from elm") ] [ text "Say hello" ]
        , button [ onClick (SetClipboard "Tauri is awesome!") ] [ text "Set clipboard" ]
        , div [] [ text model.clipboardMessage ]
        ]
