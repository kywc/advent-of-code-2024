{- cabal:
build-depends:
  base
  containers
-}
import Prelude hiding ( foldr )
import Data.Map.Strict ( Map, fromListWith, foldr )
import Data.Set ( Set, fromList, union, size, empty )
import Data.Char ( isPunctuation )
import Control.Monad ( join )

type Pos = (Int,Int)  
-- (+~>) = join $ (+) *** (+)    :: Pos -> Pos -> Pos
-- (-~>) = join $ (-) *** (-)    :: Pos -> Pos -> Pos
(+~>) v@(x1,y1) w@(x2,y2) = (x1+x2,y1+y2)
(-~>) v@(x1,y1) w@(x2,y2) = (x1-x2,y1-y2)


antinodes2 :: Pos -> Pos -> [Pos]
antinodes2 p q = let d   = p -~> q
                     inbd n = (n >= 0) && (n < 130)
                     inBounds v@(x,y) = (inbd x) && (inbd y)
                 in
  filter inBounds [q +~> d, p -~> d]

antinodesAll :: [Pos] -> Set Pos
antinodesAll = fromList . concat . antinodesList
      where antinodesList (x:xs) = concat (map (antinodes2 x) xs) : antinodesList xs 

state :: IO (Map Char [Pos])
state = do 
    cells <- readFile "input"
    let locs = concat $ zipWith (uncurry map) (map (,) [0..]) $ map (zip [0..]) $ lines cells
    return $ fromListWith (++) $ scour (not . isPunctuation) locs
  where assoc (a,(b,c)) = (c,(a,b):[])
        scour p         = map (filter (p . fst) . assoc)   

antinodesTotal :: Map Char [Pos] -> Set Pos
antinodesTotal m = foldr union empty $ fmap antinodesAll m

main :: IO ()
main = state >>= (\x -> print $ size $ antinodesTotal x)
