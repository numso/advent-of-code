module DayEighteen.App where

import DayEighteen.Code exposing (parseInput, tick)
import DayEighteen.Input exposing (input)
import Native.FlipCoin

import Array exposing (Array)
import Graphics.Collage exposing (..)
import Color exposing (Color, black, white)
import StartApp exposing (start)
import Html exposing (Html)
import Effects exposing (Effects)
import Time

flipCoin : () -> Bool
flipCoin _ = Native.FlipCoin.flipCoin ()

app = start { init = init, view = view, update = update, inputs = [loop] }

main = app.html

loop = Signal.map (\_ -> Tick) (Time.every (50 * Time.millisecond))

-- MODEL

gameSize = 100

type alias Model = Array (Array Bool)

init : (Model, Effects Action)
-- init = (parseInput input, Effects.none)
init = (generateBoard gameSize, Effects.none)

generateBoard : Int -> Array (Array Bool)
generateBoard size =
  Array.map (\_ -> generateLine size) (Array.fromList [1..size])

generateLine : Int -> Array Bool
generateLine size =
  Array.map (\_ -> flipCoin ()) (Array.fromList [1..size])

-- UPDATE

type Action
  = Tick

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Tick -> (tick model, Effects.none)

-- VIEW

size = 5

view : Signal.Address Action -> Model -> Html
view address model =
  Html.fromElement (collage (gameSize * 10) (gameSize * 10) (renderBoard model))

renderBoard : Array (Array Bool) -> List Form
renderBoard board =
  let chunks = Array.indexedMap renderLine board in
    Array.foldl (++) [] chunks

renderLine : Int -> Array Bool -> List Form
renderLine x line =
  Array.toList (Array.indexedMap (renderCell x) line)

renderCell : Int -> Int -> Bool -> Form
renderCell x y val =
  let color = if val then black else white in
    renderBlock x y color

renderBlock : Int -> Int -> Color -> Form
renderBlock x y color =
  move ((toFloat x) * size, (toFloat y) * size) (filled color (square size))
