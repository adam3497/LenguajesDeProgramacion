{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
{-# HLINT ignore "Use isJust" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
{-# HLINT ignore "Use newtype instead of data" #-}
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
merge [xs] = xs
merge (xs:ys:xss) = merge $ merge' xs ys : xss
               where
                  merge' [] ys = ys
                  merge' xs [] = xs
                  merge' (x:xs) (y:ys)
                     | x <= y = x : merge' xs (y:ys)
                     | otherwise = y : merge' (x:xs) ys

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


{- Problema 8
   Función general de separePorComas y enLineasSeparadas
-}
separadoPor :: String -> [String] -> String
separadoPor opcion [] = ""
separadoPor opcion (x:xs) = x ++ (if null xs then "" else opcion ++ " " ++ separadoPor opcion xs)

{- Problema 9 - ver problema9.hs -}

{- Problema 10
   Función que toma una lista de Integers, y retorna una lista con cada elemento duplicado
-}
dupliqueTodo :: [Integer] -> [Integer]
dupliqueTodo [] = []

-- Función dupliqueTodo usando la comprensión de listas
--dupliqueTodo integers = [x*2 | x <- integers]

-- Función dupliqueTodo usando foldr
dupliqueTodo integers = foldr (f) [] integers
                           where f x y = x*2 : y

{- Problema 11 - ver archivo problema11.hs -}

{- Problema 12 
   Funciones para tipo de dato data Tree a
-}

data Tree a = Node a [Tree a] deriving Show

-- 1 Función sumTree que suma todos los nodos del árbol
sumeTree :: Tree Integer -> Integer
sumeTree tree = case preorderTree tree of
                  [] -> 0
                  xs -> sum xs

{- 2
   Función que trasnforma una estructura de dato de tipo "Tree a" a una lista 
   en preorder con todos sus nodos 
-}
preorderTree :: Tree Integer -> [Integer]
preorderTree (Node a []) = [a]
preorderTree (Node a (x:xs)) = a : preorderTree x ++ foldr (f) [] xs
                                                   where f y z = preorderTree y ++ z

-- 3 Declaración Haskell instance que hace que Tree sea una instancia de la clase Functor
{- instance Functor Tree where
   fmap :: (a -> b) -> Tree a -> Tree b
   fmap f (Node a []) = Node (f a) []
   fmap f (Node a (x:xs)) = Node (f a) ([fmap f x] ++ foldr (g) [] xs)
                                                      where g y z = fmap f y : z -}

-- 4 Función foldTree análoga a la función foldr para listas 
foldTree :: (a -> b -> c) -> (c -> b -> b) -> b -> Tree a -> c
foldTree f g z (Node a ts) = f a (foldr (g . foldTree f g z) z ts)

-- Funciones creadas en los puntos anteriores pero ahora utilizando el foldTree 
sumTree' :: Tree Integer -> Integer
sumTree' = foldTree (+) (+) 0
preorderTree' :: Tree a -> [a]
preorderTree' = foldTree (:) (++) []

instance Functor Tree where
   fmap :: (a -> b) -> Tree a -> Tree b
   fmap f = foldTree (Node . f) (:) []


{- Problema 13
   Definición de un tipo data Set a el cual permite funciones como conjunto, union, interseccion,
   miembro y complemento
-}
data Set a = Set (a -> Bool)

conjunto :: (a -> Bool) -> Set a
conjunto = Set

myUnion :: Set a -> Set a -> Set a
myUnion (Set f) (Set g) = Set (\x -> f x || g x)

interseccion :: Set a -> Set a -> Set a
interseccion (Set f) (Set g) = Set (\x -> f x && g x)

miembro :: Set a -> a -> Bool
miembro (Set f) = f

complemento :: Set a -> Set a
complemento (Set f) = Set (not . f)

{- Problema 14 -}
data Exp = BoolLit Bool | IntLit Integer | CharLit Char
         | Sub Exp Exp
         | Equal Exp Exp 
         | If Exp Exp Exp 
data OType = OBool | OInt | OChar | OWrong 
               deriving (Eq, Show)

-- Función que toma una Exp y retorna su OType 
tipoDe :: Exp -> OType
tipoDe (BoolLit _) = OBool
tipoDe (IntLit _) = OInt
tipoDe (CharLit _) = OChar
tipoDe (Sub e1 e2) = case (tipoDe e1, tipoDe e2) of
                        (OInt, OInt) -> OInt
                        _ -> OWrong
tipoDe (Equal e1 e2) = case (tipoDe e1, tipoDe e2) of
                        (OInt, OInt) -> OBool
                        (OChar, OChar) -> OBool
                        (OBool, OBool) -> OBool
                        _ -> OWrong
tipoDe (If e1 e2 e3) = case (tipoDe e1, tipoDe e2, tipoDe e3) of
                        (OBool, t1, t2) -> if t1 == t2 then t1 else OWrong
                        _ -> OWrong



