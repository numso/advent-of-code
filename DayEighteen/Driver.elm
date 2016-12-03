module DayEighteen.Driver where

import DayEighteen.Code exposing (runGame, lightCorners)
import DayEighteen.Input exposing (input, testInput)

part1 = runGame identity 100 input -- 814
test1 = runGame identity 4 testInput -- 4

part2 = runGame lightCorners 100 input -- 924
test2 = runGame lightCorners 5 testInput -- 17
