{- cabal:
build-depends:
  base
  containers
-}
import Data.Map.Strict ( Map, fromListWith )
import Data.Set ( Set, fromList, unions, size )
import Data.Char ( isPunctuation )
import Control.Arrow ( (&&&), (***) )
import Control.Monad ( join )

type Pos = (Int,Int)  
(+~>) = join $ (+) *** (+)    :: Pos -> Pos -> Pos
(-~>) = join $ (-) *** (-)    :: Pos -> Pos -> Pos

antinodes2 :: Pos -> Pos -> [Pos]
antinodes2 p q = let d   = p -~> q
                     (u) = (and) $ (>=0) &&& (<130)    :: Int -> Bool
                 in
  filter (join $ (u) *** (u)) [q +~> d, p -~> d]

antinodesAll :: [Pos] -> Set Pos
antinodesAll = fromList antinodesList
      where antinodesList (x:xs) = join (map (antinodes2 x) xs) : antinodesList xs 

state :: IO (Map Char [Pos])
state = do 
    cells <- readFile "input"
    let locs = join $ zipWith map (map (,) [0..]) $ map (zip [0..]) lines cells
    fromListWith (++) scour (not isPunctuation) locs
  where assoc   = \(a,(b,c)) -> (c,[(a,b)]) 
        scour p = map (filter (p . snd) $ assoc)         :: (Char -> Bool) -> [(Int,(Int,Char))]
                                                                           -> [ (Char , [Pos]) ]

antinodesTotal :: Map Char [Pos] -> Set Pos
antinodesTotal = unions $ map antinodesAll

main :: IO ()
main = state >>= (\x -> print $ size $ antinodesTotal x)
