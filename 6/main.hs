{- cabal:
build-depends:
  base
-}
type Pos = (Int,Int)
data Dir = N | S | E | W
data Endpt = Endpt { pos :: Pos, dir :: Dir }
type Trail = [Endpt]
type Obstacles = [Pos]

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
