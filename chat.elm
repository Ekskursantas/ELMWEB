module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import List
import WebSocket


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { chatMessage : List String
    , userMessage : String
    , login : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" ""
    , Cmd.none
    )


type alias ChatMessage =
    { command : String
    , content : String
    }



-- UPDATE


type Msg
    = PostChatMessage
    | UpdateUserMessage String
    | NewChatMessage String
    | PostLoginInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PostLoginInput user ->
            { model | login = user } ! []

        PostChatMessage ->
            let
                message =
                    model.login ++ ":: " ++ model.userMessage
            in
            { model | userMessage = "" }
                ! [ WebSocket.send "ws://localhost:3000/" message ]

        UpdateUserMessage message ->
            { model | userMessage = message } ! []

        NewChatMessage message ->
            { model | chatMessage = message :: model.chatMessage } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "username..."
            , autofocus True
            , value model.login
            , onInput PostLoginInput
            ]
            []
        , input
            [ placeholder "message..."
            , autofocus False
            , value model.userMessage
            , onInput UpdateUserMessage
            ]
            []
        , button [ onClick PostChatMessage ] [ text "Submit" ]
        , div []
            [ li []
                [ writeDownMessages model ]
            ]
        ]


writeDownMessages : Model -> Html Msg
writeDownMessages model =
    model.chatMessage
        |> List.map (deComp model)
        |> ul []


deComp : Model -> String -> Html Msg
deComp model message =
    let
        fixedContent =
            fixString (Decode.decodeString (Decode.field "content" Decode.string) message)
    in
    li []
        [ text fixedContent ]


fixString : Result String String -> String
fixString message =
    case message of
        Ok val ->
            val

        Err err ->
            err



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://localhost:3000" NewChatMessage
