fun main() {
    // Lista de sólo lectura
    

    // Lista mutable con declaración de tipo explícito
    var shapes: MutableList<String> = mutableListOf("triangle", "square", "circle")

    val readOnlyShapes = listOf("triangle", "square", "circle")

    // Las listas son ordenadas, se usa un índice
    println("The first item in the list is: ${readOnlyShapes[0]}")

    // Obtener el primer o último elemento
    val first = readOnlyShapes.first()
    val last = readOnlyShapes.last()

    // Número de ítems en la lista
    val count = readOnlyShapes.count()

    // Verificar que un ítem esté en la lista
    val isInList = "circle" in readOnlyShapes // true


    // Agregar y eliminar ítems
    shapes.add("pentagon") // [triangle, square, circle, pentagon]
    shapes.remove("pentagon") // [triangle, square, circle]


    // Set de sólo lectura
    val readOnlyFruit = setOf("apple", "banana", "cherry", "cherry")

    // Set mutable con tipo explícito
    var fruit: MutableSet<String> = mutableSetOf("apple", "banana", "cherry", "cherry")

    // Número de ítems en el set
    val setCount = readOnlyFruit.count()
    // Verificar que un ítem está dentro del set
    val isInSet = "banana" in readOnlyFruit // true

    // Agregar o eliminar ítems de un set mutable
    fruit.add("dragonfruit") // [apple, banana, cherry, dragonfruit]
    fruit.remove("dragonfruit") // [apple, banana, cherry]

    // Map de sólo lectura
    val readOnlyAccountBalances = mapOf(1 to 100, 2 to 100, 3 to 100)

    // Map mutable con tipo explícito
    var accountBalances: MutableMap<Int, Int> = mutableMapOf(1 to 100, 2 to 100, 3 to 100)

    // Accesar un valor del Map
    val someValue = readOnlyAccountBalances[2] // se usa la llave

    // Número de elementos dentro del Map
    val mapCount = readOnlyAccountBalances.count()

    // Agregar o eliminar elemento de un Map mutable
    accountBalances.put(4, 100) // llave=4, valor=100
    accountBalances.remove(4) // se usa la llave para eliminar el elemento

    // verificar si una llave ya está en el Map
    val isInKey = readOnlyAccountBalances.containsKey(2) // true

    // Obtener las keys y los values
    val keys = readOnlyAccountBalances.keys
    val values = readOnlyAccountBalances.values

    // Verificar si una key o value está en el map
    println(2 in readOnlyAccountBalances.keys) // true
    println(200 in readOnlyAccountBalances.values) // false

}