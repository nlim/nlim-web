module Lib
    ( fibs
    ) where


fibs :: [Int]
fibs = 1 : 1 : Prelude.zipWith (+) fibs (Prelude.tail fibs)
