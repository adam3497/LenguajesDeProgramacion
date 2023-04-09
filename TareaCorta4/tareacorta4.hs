{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
{-# HLINT ignore "Use isJust" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
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

{- 1
   Función que evalúa True cuando para cada par (x,y) en la lista, no hay otro par 
   (x,z) en la lista tal que y /= z
-}
esFuncion :: (Eq a, Eq b) => (RelBinaria a b) -> Bool
esFuncion [] = True
esFuncion [(x,y)] = True
esFuncion (x:xs) =   if lookup (fst x) xs /= Nothing && lookup (fst x) xs /= Just (snd x)
                        then False
                     else esFuncion xs

{- 2
   Función que devuelve una composición de los argumentos, si y solo si, existe un par (x y)
   en la relación dada como primer argumento, y hay otro par (y z) en la relación dada como 
   segundo argumento, tal que el resultado sea (x z) 
-}
compongaRel :: (Eq a, Eq b, Eq c) => (RelBinaria a b) -> (RelBinaria b c) -> (RelBinaria a c)
compongaRel [] [] = []
compongaRel [] (y:ys) = []
compongaRel (x:xs) [] = []
compongaRel ((a,b):xs) (y:ys) =  ([(a, snd y) | b == fst y])
                                    ++ compongaRel [(a,b)] ys
                                    ++ compongaRel xs (y:ys)

{- Problema 6
   Función que toma una lista de hileras y devuelve una única hilera que contiene a todas las 
   hileras separadas por comas
-}
separePorComas :: [String] -> String
separePorComas [] = ""
separePorComas (x:xs) = x ++ (if null xs then "" else ", " ++ separePorComas xs) 

{- Problema 7
   Función que toma una lista de strings y evalúa a un único string que cuando es impreso
   muestra las hileras en lineas separadas
-}
enLineasSeparadas :: [String] -> String
enLineasSeparadas [] = ""
enLineasSeparadas (x:xs) = x ++ "\n" ++ (if null xs then "" else enLineasSeparadas xs)
-- enLineasSeparadas con la función unlines del Prelude de Haskell
-- enLineasSeparadas strings = unlines strings 

