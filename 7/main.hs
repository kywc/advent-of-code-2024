{- cabal:
build-depends:
  base
-}
import Data.Maybe ( catMaybes )

(|||) :: Int -> Int -> Int
a ||| b = read $ (show a) ++ (show b)

possibilitiesExpand :: [Int] -> [Int] -> [Int]
possibilitiesExpand l []     = l
possibilitiesExpand l (x:xs) = possibilitiesExpand (l >>= \y -> [y ||| x, y + x, y * x]) xs 

resultWhenPossible :: Int -> [Int] -> Maybe Int
resultWhenPossible value equation
            | value `elem` possibilitiesExpand [x] xs = Just value
            | otherwise                               = Nothing
            where (x:xs) = equation

xtract :: String -> (Int, [Int]) 
xtract = (\x -> ((read . init . head) x, map read (tail x))) . words

main :: IO ()
main = do
  file <- readFile "input"
  let possible = map xtract $ lines file
  print $ sum $ catMaybes $ map (\(a,b) -> resultWhenPossible a b) possible 
