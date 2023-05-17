module Program1 where

double :: Int -> Int
double n = n + n

double' :: Int -> Int -> Int
double' n1 n2 = 2*(n1+n2)

f :: (Integral n) => n -> Bool
f n = n `rem` 3 == 0

{-
La función filtro permite tomar una función f y aplicarla a cada
elemento de la lista, si el elemento cumple con la función f, entonces
el elemento se guarda, de lo contrario se ignora y elimina de la lista
-}
filtro :: (a -> Bool) -> [a] -> [a]
filtro f xs = [x | x <- xs, f x]

fb :: Int -> Int
fb 0 = 0
fb 1 = 1
fb 2 = 1
fb n = fb (n-1) + fb (n-2)

fbs :: Int -> [Int]
fbs n = fb n : (if n-1 == -1 then [] else fbs (n-1))
fbl :: Int -> [Int]
fbl n = reverse (fbs n)

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =  quicksort [y | y <- xs, y<x]
                    ++ [x]
                    ++ quicksort [y | y <- xs, y>=x]
