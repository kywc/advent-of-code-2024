#!/usr/bin/env cabal
{- cabal:
exposed-modules:
  Part2
build-depends:
  base,
  parsec
-}

import Text.Parsec.String (Parser, parseFromFile)
import Text.Parsec.Char (skipMany, noneOf, string)
import Text.Parsec.Token (decimal)
import Data.Bifunctor (bimap)
import Control.Applicative ((<$>), (<*>), liftA2, (>>))

dontDo :: Parser ()
dontDo = let thenDo = string "do()" <|> (anyChar >> thenDo)
            in do 
              string "don't()"
              thenDo

mulResult :: Parser Integer
mulResult = between "mul(" ")" $ liftA2 (*) decimal (char ',' >> decimal)

main :: Either (IO ()) (IO ())
main = let consume = ((+0) <$> dontDo) <|> (liftA2 (+) mulResult consume)
    in bimap print print $ parseFromFile consume "input"
      
