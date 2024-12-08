{- cabal:
build-depends:
  base
  containers
-}
import Data.Map.Strict ( fromListWith )
import Data.Set ( fromList, unions, size )
import Control.Arrow ( (&&&), (***) )

type Pos = (Int,Int)  -- vector addition and subtraction
(+~>) = (+) *** (+)    :: Pos -> Pos -> Pos
(-~>) = (-) *** (-)    :: Pos -> Pos -> Pos

antinodes2 :: Pos -> Pos -> [Pos]
antinodes2 p q = let d        = p -~> q
                     inBounds = (and) (>=0) &&& (<130)    :: Int -> Bool
                 in
  filter (inBounds *** inBounds) [q +~> d, p -~> d]

antinodesAll :: [Pos] -> Set Pos
antinodesAll = fromList antinodesList
      where antinodesList (x:xs) = join (map (antinodes2 x) xs) : antinodesList xs 

state :: IO Map Char [Pos]
state = do 
    cells <- readFile "input"
    let locs = join $ zipWith map (map (,) [0..]) $ map (zip [0..]) lines cells
    fromListWith (++) scour (not isPunctuation) locs
  where assoc   = \(a,(b,c)) -> (c,[(a,b)]) 
        scour p = map (filter (p . snd) $ assoc)         :: (Char -> Bool) -> List (Int,(Int,Char))
                                                                           -> List (Char,[Pos])

antinodesTotal :: Map Char [Pos] -> Set Pos
antinodesTotal = unions $ map antinodesAll

main :: IO ()
main = state >>= (\x -> print $ size $ antinodesTotal x)
