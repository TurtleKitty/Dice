
module Main where

import Data.List
import qualified Data.Text as DT
import System( getArgs )
import Text.Printf


-- Polynomail lists:

instance Num a => Num [a] where
    (f:fs) + (g:gs) = f+g : fs+gs
    fs + [] = fs
    [] + gs = gs

    (f:fs) * (g:gs) = f*g : [f]*gs + fs*(g:gs)
    _ * _ = []

    abs           = undefined
    signum        = map signum
    fromInteger n = [fromInteger n]
    negate        = map (\x -> -x)

type Poly = [Int]

trip1 (a,b,c) = a
trip2 (a,b,c) = b
trip3 (a,b,c) = c

mkpoly :: Int -> Poly
mkpoly n = map (\x -> if (x == 0) then 0 else 1) [0..n]

mkroll :: Int -> Int -> [Poly]
mkroll n d = foldl (\acc x -> acc ++ [(mkpoly d)]) [] [1..n]

splitD :: String -> [DT.Text]
splitD xdy = DT.splitOn (DT.pack "d") (DT.pack xdy)

splitND :: String -> (Int, Int)
splitND xdy = ( read $ DT.unpack $ (splitD xdy) !! 0 :: Int, read $ DT.unpack $ (splitD xdy) !! 1 :: Int)

parse :: [String] -> ([Poly], Int, Int)
parse args = foldl (\acc x ->
    if (isInfixOf "d" x)
	then ((trip1 acc) ++ (mkroll (fst (splitND x)) (snd (splitND x))), trip2 acc, (trip3 acc) * (snd $ splitND x)^(fst $ splitND x))
	else (trip1 acc, (trip2 acc) + (read x ::Int), trip3 acc))
    ([], 0, 1) args

hg :: Float -> String
hg n = map (\x -> '#') [1 .. (500 * n)] 

coolRound x n = (floor (scalar * x)) / scalar
    where scalar = 10 ** n

main = do
    args <- getArgs
    let parsed	= parse args
    let bigpoly = map (\x -> (fromIntegral x) / (fromIntegral (trip3 parsed))) $ foldl1 (*) $ trip1 parsed
    let adder	= trip2 parsed
    let combos	= trip3 parsed
    let output	= unlines $ map (\idx -> printf "%d\t\t%.5f\t\t%s" (idx + adder) (bigpoly !! idx) (hg (bigpoly !! idx))) $ filter (\idx -> (bigpoly !! idx) > 0) [0..(length bigpoly - 1)]
    putStrLn ""
    putStr output
    putStrLn ""


