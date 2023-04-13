merge :: (Ord a) => [[a]] -> [a]
merge [] = []
merge [xs] = xs
merge (xs:ys:xss) = merge $ merge' xs ys : xss
                    where 
                        merge' [] ys = ys
                        merge' xs [] = ys
                        merge' (x:xs) (y:ys) 
                            | x <= y = x : merge' xs (y:ys)
                            | otherwise = y : merge' (x:xs) ys