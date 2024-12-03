#!/usr/bin/env cabal
{- cabal:
default-extensions:
  OverloadedStrings
build-depends:
  base,
  megaparsec
-}

import Text.Megaparsec
import Text.Megaparsec.Char (string, printChar, char)
import Text.Megaparsec.Char.Lexer (decimal)
import Data.Bifunctor (bimap)
import Control.Monad (void)
import Control.Monad.Trans.Writer.CPS (WriterT)

-- type Parser = ParsecT () String (WriterT Integer IO)
type Parser = ParsecT () String
type ParseError = ParseErrorBundle String ()

dontDo :: Parser String
dontDo = let thenDo = (string "do()") <|> (anySingle *> thenDo) in
    do 
     string "don't()"
     thenDo

mulResult :: Parser Integer
mulResult = between (string "mul(") (string ")") $ liftA2 (*) decimal (char ',' >> decimal)

main :: IO () -- (consume: Parser Integer) \mapsto IO (Either ParseError Integer)
main = let consume = (eof >> return 0)  <|> (dontDo >> consume)
                                        <|> liftA2 (+) (mulResult <|> return 0) consume
                                        -- <|> (anySingle >> consume)
    in runParser consume "" <$> readFile "input" >>= \result -> print result
      
