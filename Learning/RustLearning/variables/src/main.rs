const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;

fn main() {
    let x = 5;
    let x = x + 1;

    {   // The value of x is shadowed within this scope but once it ends, x goes back to x + 1
        let x = x * 2;
        println!("The value of x in the inner scope is: {x}");
    }

    println!("The value of x is: {x}");

    // Cambiar el tipo de dato de una variable
    let spaces = "    ";
    let spaces = spaces.len();

    println!("The amount of spaces is: {spaces}");

    println!("Three hours in seconds is: {THREE_HOURS_IN_SECONDS}");
}
