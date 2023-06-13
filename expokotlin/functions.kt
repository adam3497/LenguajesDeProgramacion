fun sum(x: Int, y: Int): Int {
    return x + y
}

// Se omite el tipo de retorno porque Kotlin lo infiere
fun sum(x: Int, y: Int) = x + y 

// Acá se usa un valor por defecto para el parámetro prefix
fun printMessageWithPrefix(message: String, prefix: String = "Info") {
    println("[$prefix] $message")
}

fun main() {
    printMessageWithPrefix(prefix = "Log", message = "Hello")
    // [Log] Hello
}

