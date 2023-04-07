module TareaCorta4 where

-- Función que aproxima la derivada de una función f en un punto x
diff :: (Real a, Fractional a) => (a -> a) -> a -> a -> a
diff f x delta = (f (x+delta) - f x) / delta

-- Función que toma un valor inicial para delta, la función y un punto x, y retorna una serie lista infinita
-- aproximaciones a la derivada de f en el punto f
difAprox :: (Real a, Fractional a) => a -> (a -> a) -> a -> [a]
difAprox delta f x = diff f x delta : difAprox (delta / 2) f x

