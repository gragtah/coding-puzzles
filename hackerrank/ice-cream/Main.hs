{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

import Control.Applicative ((<$>))
import Data.Foldable (forM_)
import Data.List (sortBy, find)
import Data.Maybe (fromMaybe)
import Data.Ord (comparing)
import Data.Traversable (forM)

-- Polyfill for base < 4.8
sortOn :: Ord b => (a -> b) -> [a] -> [a]
sortOn f =
  map snd . sortBy (comparing fst) . map (\x -> let y = f x in y `seq` (y, x))

run :: IO (Int, Int)
run = do
    (m :: Int)           <- read <$> getLine
    (n :: Int)           <- read <$> getLine
    (xs :: [(Int, Int)]) <- reverse <$> sortOn snd <$> zip [1..] <$> (fmap read . words) <$> getLine

    let r = f m [] xs

    return . sortTuple . head . filter ((/= 0) . snd) $ r

 where
    f :: Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
    f m acc (x:xs) =
        let a = m - snd x
            maybeMatch = fst <$> find ((== a) . snd) xs
        in f m ((fst x, fromMaybe 0 maybeMatch) : acc) xs
    f m acc _ = acc

    sortTuple :: (Int, Int) -> (Int, Int)
    sortTuple (a, b)
        | a > b     = (b, a)
        | otherwise = (a, b)

main :: IO ()
main = do
    (t :: Int) <- read <$> getLine
    res <- forM [0..(t - 1)] $ const run
    forM_ res $ \(a, b) -> putStrLn $ unwords [show a, show b]
