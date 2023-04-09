module MiAppend where
import Prelude hiding ((++))
(++) :: [a] -> [a] -> [a]
xs ++ ys = foldr (:) ys xs 