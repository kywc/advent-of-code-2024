{- cabal:
build-depends:
  base
-}
type Pos = (Int,Int)
data Dir = N | S | E | W
data Endpt = Endpt { pos :: Pos, dir :: Dir }
type Trail = [Endpt]

state :: IO ([Pos], Pos)
state = do 
    cells <- readFile "input"
    let locs = flatten $ zipWith map (map (,) [1..]) $ map (zip [1..]) lines cells
    (,) (scour '#' locs) $ fst (scour '^' locs)
  where assoc   = \(a,(b,c)) -> ((a,b),c) 
        scour c = map (fst $ filter (elem c . snd) $ assoc)

way :: Dir -> (Int, Int)
way N = (-1, 0)
way S = (1, 0)  
way E = (0, 1)  
way W = (0, -1) 

turnR :: Dir -> Dir
turnR N = E
turnR E = S
turnR S = W
turnR W = N

getBlocking :: [Pos] -> Pos -> Dir -> Maybe Pos
getBlocking ob p d =
    let part = (\a b -> f a `compare` f b) [ ob | (x, y) <- ob, f ob `g'` f p, f' ob == f' p ]
          in if (null part) then Nothing else Just (g part)
    where (f, f') = if ((Dir == N) || (Dir == S)) then (fst, snd) else (snd, fst)
          (g, g') = if ((Dir == N) || (Dir == S)) then (maximumBy, (<)) else (minimumBy, (>))

next :: Endpt -> Maybe Endpt
next pt = case pos' of
             Just(end) -> Just Endpt { pos = end, dir = turnR d }
             Nothing   -> Nothing
  where
    (p, d) = (pos pt, dir pt)
    pos' = getBlocking obstacles p d
