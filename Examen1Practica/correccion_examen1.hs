module CorreccionExamen1 where

-- Función que retorna todos los valores asociados con un x en una lista
veces :: Eq a => a -> [(a,b)] -> [b]
veces x [] = []
veces x ((a, b):ys) =  if a == x then b : veces x ys else veces x ys

-- Función que toma dos listas y retorna la intersección de las listas
interseccion :: (Eq a) => [a] -> [a] -> [a]
interseccion [] ys = []
interseccion xs [] = []
interseccion (x:xs) ys = if x `elem` ys
                            then x : interseccion xs ys
                            else interseccion xs ys


-- Función que elimina un valor en un árbol binario de búsqueda
data Arbol a = Nodo a (Arbol a) (Arbol a) | Hoja deriving (Show)

eliminarValor :: Ord a => a -> Arbol a -> Arbol a
eliminarValor _ Hoja = Hoja
eliminarValor valor (Nodo raiz izquierda derecha)
    | valor < raiz = Nodo raiz (eliminarValor valor izquierda) derecha
    | valor > raiz = Nodo raiz izquierda (eliminarValor valor derecha)
    | otherwise    = eliminarNodo raiz izquierda derecha

eliminarNodo :: Ord a => a -> Arbol a -> Arbol a -> Arbol a
eliminarNodo _ Hoja derecha = derecha
eliminarNodo _ izquierda Hoja = izquierda
eliminarNodo _ izquierda (Nodo _ Hoja derecha) = Nodo (valorMinimo derecha) izquierda (eliminarValor (valorMinimo derecha) derecha)
eliminarNodo _ izquierda (Nodo _ izquierdaDerecha derecha) = Nodo raiz izquierda (eliminarValor raiz derecha)
  where
    raiz = valorMinimo izquierdaDerecha
    izquierda = eliminarValor raiz izquierdaDerecha

valorMinimo :: Arbol a -> a
valorMinimo (Nodo raiz Hoja _) = raiz
valorMinimo (Nodo _ izquierda _) = valorMinimo izquierda
valorMinimo Hoja = error "El árbol está vacío."
