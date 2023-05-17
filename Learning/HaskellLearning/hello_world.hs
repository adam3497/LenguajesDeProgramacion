module HelloWorld where

main :: IO ()
main = putStrLn "Hello, world"

double :: Int -> Int
double f = f+f

suma :: Integer -> Integer -> Integer
suma a b = sum [a..b]

division :: Int -> Int -> Int
division x y = x `div` y

cuadrado :: Int -> Int
cuadrado x = x*x