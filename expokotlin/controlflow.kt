fun main() {
    val d: Int 
    val check = true

    if (check) {
        d = 1
    } else {
        d = 2
    }

    println(d)
    // 1


    val a = 1
    val b = 2
    println(if (a > b) a else b) // Returns a value: 2

    val obj = "Hello"
    when (obj) {
        "1" -> println("One")
        "Hello" -> println("Greeting")
        // default
        else -> println("Uknown")
    }

    // For loop con un rango
    for (number in 1..5) {
        println(number)
    }

    // For loop sobre una colección
    val cakes = listOf("carrot", "cheese", "chocolate")
    for (cake in cakes) {
        println("Yummy, it's a $cake cake!")
    }

    // While loop
    var cakesEaten = 0
    while (cakesEaten < 3) {
        println("Eat a cake")
        cakesEaten++
    }

    // do-while loop
    var cakesBaked = 0
    do {
        println("Bake a cake")
        cakesBaked++
    } while (cakesBaked < cakesEaten)
}