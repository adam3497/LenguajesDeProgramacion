fun uppercaseString(string: String): String {
    return string.uppercase()
}

// Usando expresiones lambda
fun main() {
    println({ string: String -> string.uppercase() }("hello"))

    // Asignar a una variable
    val upperCaseString = { string: String -> string.uppercase() }
    println(upperCaseString("hello"))
    // Pasar a otra función
    val numbers = listOf(1, -2, 3, -4, 5, -6)
    val positives = numbers.filter { x -> x > 0 }
    println(positives) // [1, 3, 5]

    // Usando map
    val doubled = numbers.map { x -> x * 2 } 
    println(doubled) // [2, -4, 6, -8, 10, -12]

    // Tipos de funciones
    // (String) -> String o (Int, Int) -> Int 
    val upperCaseString: (String) -> String = { string -> string.uppercase() }
}

// Ejemplo retornando una expresión lambda en una función
fun toSeconds(time: String): (Int) -> Int = when (time) {
    "hour" -> { value -> value * 60 * 60 }
    "minute" -> { value -> value * 60 }
    "second" -> { value -> value }
    else -> { value -> value }
}

fun main() {
    val timesInMinutes = listOf(2, 10, 15, 1)
    val min2sec = toSeconds("minute")
    val totalTimeInSeconds = timesInMinutes.map(min2sec).sum()
    println("Total time is $totalTimeInSeconds secs")
    // Total time is 1680 secs

    // Trailing lambda
    println(listOf(1, 2, 3).fold(0, { x, item -> x + item }))
    // Se puede escribir de la siguiente manera
    println(listOf(1, 2, 3).fold(0) { x, item -> x + item })
}