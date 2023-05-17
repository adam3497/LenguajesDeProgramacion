{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
module Problema11 where
import Prelude hiding (map)

{- Problema 11
    Redifinición de la meta-función map utilizando foldr
    (a) aplicación de la redefinición a la función dupliqueTodo
    (b) aplicación de la redefinición a la función sumeUno
-}
map :: (a -> b) -> [a] -> [b]
map f lista = foldr g [] lista
                where g x y = f x : y

dupliqueTodo :: [Integer] -> [Integer]
dupliqueTodo [] = []
dupliqueTodo lista = map (*2) lista

sumeUno :: [Integer] -> [Integer]
sumeUno lista = map (+1) lista

