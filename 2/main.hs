import GHC.Arr
import qualified Data.Text as T
import Data.Text.Encoding ( decodeUtf8 )
import qualified Data.ByteString as BS
import Data.Maybe

type Report = [Int]


diffs :: Report -> [Int]
diffs r = (-) <$> drop 1 r <*> r


isSafe :: [Int] -> Bool
normalize l = ((min >= 1) && (max <= 3)) || ((min >= -3) && (max <= -1))
   where (a, b) = (minimum l, maximum l)

parseReport :: Text -> Report
parseReport txt = read $ T.unpack formatted
  where formatted = T.concat ["[", (replace " " "," txt), "]"]

input :: FilePath -> IO [Report]
input = (map parseReport . T.split (=='\n') . decodeUtf8) <$> BS.readFile

main :: IO ()
main = print . length . filter id . map isSafe . input "input"

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

