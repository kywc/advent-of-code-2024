{- cabal:
build-deps:
  base
  lens
-}
import Data.List ( concat, transpose )
import Control.Lens
import qualified Control.Lens.Internal.Deque as Deque

type Length = Int
type Chunk = (Length, Int)  -- id is second and set convention free space is id 0

idNum :: [Int]
idNum = let idNumFrom n = n : 0 : idNumFrom (n+1)
  in idNumFrom 1

readDisk :: String -> [Chunk]
readDisk raw = zip (map fromEnum raw) idNum

fillHoleWith :: Chunk -> Chunk -> (Chunk, Either Chunk Chunk)
fillHoleWith hole@(l,i) file@(m,j)
    | l <  m  = ( (l,j), Right (m-l,j) ) 
    | l >= m  = ( (m,j), Left (l-m,0) )
-- the (hole bigger than file) should be the case with the non-strict ineq
-- since 0 length holes are represented in the input already 

fillHolesWith :: [Chunk] -> [Chunk] -> [Chunk]
-- TODO maybe can use a Traversal ?
-- then main is something like fillHolesWith (zero ids filtered out) (reversed nonzero ids)
-- then interleave back w/ forward nonzero ids remembering to truncate somehow.
