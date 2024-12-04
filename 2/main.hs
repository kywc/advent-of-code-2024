#!/usr/bin/env cabal
{- cabal:
default-extensions:
  OverloadedStrings
build-depends:
  base,
  text,
  ghc
-}

import GHC.Arr
import qualified Data.Text as T
import Data.Text ( Text, pack, unpack, concat, split, replace )
-- import Data.Text.Encoding ( decodeUtf8 )
-- import qualified Data.ByteString ( readFile )
import GHC.Utils.Misc ( filterByList )
import Control.Arrow

type Report = [Int]
type Deltas = [Int]

diffs :: Report -> Deltas
diffs r = if (null diff) then [0] else diff
  where diff = zipWith (-) (drop 1 r) r

alternates :: Deltas -> [Deltas]
alternates diff
    | k < 0     = []
    | otherwise = [ take i diff ++ (fusions !! i) ++ drop (i+2) diff | i <- [0..k] ]
    where 
      fusions = zipWith (+) (drop 1 diff) diff
      k = length diff - 2

isSafe :: Deltas -> Bool
isSafe l = ((min >= 1) && (max <= 3)) || ((min >= -3) && (max <= -1))
   where (min, max) = (minimum l, maximum l)

parseReport :: Text -> Report
parseReport txt = read $ unpack formatted
  where formatted = T.concat ["[", (replace " " "," txt), "]"]

input :: FilePath -> IO [Report]
input path = readFile path >>= \x -> 
    return $ (map parseReport . split (=='\n') . pack) x

computation :: (->) [Report] (String, String)
computation = (arr (map diffs)) >>> ((arr (map isSafe)) &&& (arr (map alternates))) 
                        >>> arr (\(x,y) -> (filter id x, filterByList (map not x) y))
                        >>> second (filter id . (map or) . map (map isSafe))
                        >>> both length
                        >>> both show >> both (++"\n")
                        
main :: IO ((),())
main = fmap computation (input "input") >>= \x -> both print

{-
normalize :: Deltas -> Maybe Deltas
normalize l
   | (a >= 1) && (b <= 3) = Just l
   | (a >= -3) && (b <= -1) = Just (map negate l)
   | otherwise = Nothing
   where (a, b) = (minimum l, maximum l)
 
isSafe :: Report -> Bool
isSafe = isJust . normalize . diffs
-}

