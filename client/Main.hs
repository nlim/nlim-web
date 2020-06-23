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


biscuitMessage :: MisoString
biscuitMessage = "Me with my new puppy Biscuit in 2019"

updateModel :: Action -> Model -> Effect Action Model
updateModel (Update n) _
    | n < Just 0 = noEff Nothing
    | otherwise = noEff $ (n >>= (\i -> Safe.headMay $ Prelude.drop (i - 1) fibs ))

updateModel NoOp m = noEff m

viewModel :: Model -> View Action
viewModel x = div_ []
    [
      h1_ [class_ "header"] [ text "About Me: Nathaniel Lim" ]
    , p_  [class_ "about" ] [ text "Senior software engineer with experience in early stage product development at multiple startups.  Strong understanding and interest in functional programming and scalability practices.  Able to work in a fast-paced environment. Skilled in effective communication with engineering and product teams.  Interested in big data and machine learning practices." ]
    -- </p>
    , img_  [ src_ "me_2.jpg", width_ "300", alt_ biscuitMessage ] []
    , p_    [ class_ "footer" ] [ text biscuitMessage ]
    , h4_ [class_ "header"] [ text "Contact:" ]
    , p_    [ class_ "footer" ] [  a_ [ href_ "https://github.com/nlim"] [text "Github" ] ]
    , p_    [ class_ "footer" ] [  a_ [ href_ "https://www.linkedin.com/in/natelim/"] [text "Linkedin" ] ]
    , p_    [ class_ "footer" ] [  a_ [ href_ "mailto:nathaniel.j.lim@gmail.com"] [text "Email" ] ]
    , br_ [] []
    , p_    [ class_ "footer" ] [ text "This webpage is a cross compiled Haskell GhcJS project using the Miso framework.  The source can be found here: ", a_ [ href_ "https://github.com/nlim/nlim-web"] [text "nlim-web" ] ]
    -- </p>

    ,  h6_ [class_ "header"] [ text "Here is a fibonacci function writen in Haskell and running in Javascript:" ]
    , input_ [ onInput (Update . readMaybe . Prelude.filter (/= '"') . show) ] []
    , br_ [] []
    , text (toMisoString (show x))
    ]

main :: IO ()
main = exec
