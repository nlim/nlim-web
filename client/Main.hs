{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}


module Main where

import Lib
import Miso
import Miso.String
import Text.Read (readMaybe)
import Safe (headMay)

type Model = Maybe Int

data Action = Update (Maybe Int)
            | NoOp

exec :: IO ()
exec = startApp App {..}
  where
    initialAction = NoOp
    model  = Nothing
    update = updateModel
    view   = viewModel
    events = defaultEvents
    subs   = []

updateModel :: Action -> Model -> Effect Action Model
updateModel (Update n) _
    | n < Just 0 = noEff Nothing
    | otherwise = noEff $ (n >>= (\i -> Safe.headMay $ Prelude.drop (i - 1) fibs ))

updateModel NoOp m = noEff m

viewModel :: Model -> View Action
viewModel x = div_ []
    [
      input_ [ onInput (Update . readMaybe . Prelude.filter (/= '"') . show) ] []
    , text (toMisoString (show x))
    ]

main :: IO ()
main = exec
