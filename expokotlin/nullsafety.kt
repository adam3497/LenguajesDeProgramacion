fun describeString(maybeString: String?): String {
    if (maybeString != null && maybeString.length > 0) {
        return "String of length ${maybeString.length}"
    } else {
        return "Empty or null string"
    }
}

fun lengthString(maybeString: String?): Int? = maybeString?.length

fun main() {

    var nullString: String? = null
    println(nullString?.length ?: 0)
    // Se imprime el 0


    var nullString: String? = null
    println(lengthString(nullString))
    // null 

    var neverNull: String = "This can't be null"
    neverNull = null // error en compilación

    var nullable: String? = "You can keep a null here"
    nullable = null // This is ok

    // notNull no acepta valores nulos
    fun strLength(notNull: String): Int {
        return notNull.length
    }

    println(strLength(neverNull)) // 18
    println(strLength(nullable)) // Error de compilación
}