#!/usr/bin/env cabal
{- cabal:
default-extensions:
  OverloadedStrings
build-depends:
  base,
  text,
  bytestring
-}

import GHC.Arr
import qualified Data.Text as T
import Data.Text ( Text, pack, unpack, concat, split, replace )
import Data.Text.Encoding ( decodeUtf8 )
import qualified Data.ByteString ( readFile )
import Data.Maybe

type Report = [Int]


diffs :: Report -> [Int]
diffs r = if (null diff) then [0] else diff
  where diff = zipWith (-) (drop 1 r) r


isSafe :: [Int] -> Bool
isSafe l = ((min >= 1) && (max <= 3)) || ((min >= -3) && (max <= -1))
   where (min, max) = (minimum l, maximum l)

parseReport :: Text -> Report
parseReport txt = read $ unpack formatted
  where formatted = T.concat ["[", (replace " " "," txt), "]"]

input :: FilePath -> IO [Report]
input path = readFile path >>= \x -> 
    return $ (map parseReport . split (=='\n') . pack) x

main :: IO ()
main = fmap (show . length . filter id . map isSafe . map diffs) (input "input") >>=
   \x -> putStrLn x

{-
normalize :: [Int] -> Maybe [Int]
normalize l
   | (a >= 1) && (b <= 3) = Just l
   | (a >= -3) && (b <= -1) = Just (map negate l)
   | otherwise = Nothing
   where (a, b) = (minimum l, maximum l)
 
isSafe :: Report -> Bool
isSafe = isJust . normalize . diffs
-}

