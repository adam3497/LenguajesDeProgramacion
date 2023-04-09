{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
{-# HLINT ignore "Use isJust" #-}
{-# HLINT ignore "Redundant bracket" #-}
module TareaCorta4 where
import Data.List

-- Función que aproxima la derivada de una función f en un punto x
diff :: (Real a, Fractional a) => (a -> a) -> a -> a -> a
diff f x delta = (f (x+delta) - f x) / delta

{- Problema 1
   Función que toma un valor inicial para delta, la función f y un punto x, y retorna una serie lista infinita
   aproximaciones a la derivada de f en el punto f 
-}
difAprox :: (Real a, Fractional a) => a -> (a -> a) -> a -> [a]
difAprox delta f x = diff f x delta : difAprox (delta / 2) f x

{- Problema 2
   Función que toma una tolerancia epsilon, un valor inicial para delta, una función f, y un punto x, 
   y devuelve la aproximación de f en el punto x 
-}
derive :: (Real a, Fractional a, RealFrac a) => a -> a -> (a -> a) -> a -> a
derive epsilonT delta f x = getNumT (difAprox delta f x) epsilonT f x

getNumT :: (Real a, Fractional a, RealFrac a) => [a] -> a -> (a -> a) -> a -> a
getNumT (x:xs) epsilonT f y = if snd (properFraction x) <= epsilonT && x == head xs
                                then x else getNumT xs epsilonT f y

{- Problema 3
   Función que toma una lista de funciones, y devuelve la función que es su composición 
-}
componga :: [a -> a] -> a -> a
componga [] arg = arg
componga (f:fs) arg = f (componga fs arg)

{- Problema 4
   Función que toma una lista finita de listas ordenas y las junta en una única lista ordenada
-}
merge :: (Ord a) => [[a]] -> [a]
merge [] = []
merge [[]]  = []
merge [x:xs] = sort (x:xs)
merge ((n:ns):(m:ms)) = sort ( take 500 (n: ns ++ m ++ [y | x <- ms, y <- x]))

-- Problema 5
type RelBinaria a b = [(a,b)]

{- 
   Función que evalúa True cuando para cada par (x,y) en la lista, no hay otro par 
   (x,z) en la lista tal que y /= z
-}
esFuncion :: (Eq a, Eq b) => (RelBinaria a b) -> Bool
esFuncion [] = True
esFuncion [(x,y)] = True
esFuncion (x:xs) =   if lookup (fst x) xs /= Nothing && lookup (fst x) xs /= Just (snd x)
                        then False
                     else esFuncion xs

