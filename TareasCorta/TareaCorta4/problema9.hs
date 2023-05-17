module MiAppend where
import Prelude hiding ((++))
{- Problema 9
    Redefinición del operador ++ en listas utilizando foldr
-}
(++) :: [a] -> [a] -> [a]
xs ++ ys = foldr (:) ys xs 