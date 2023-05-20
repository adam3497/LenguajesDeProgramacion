const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;

fn main() {
    let x = 5;
    let x = x + 1;

    {   // The value of x is shadowed within this scope but once it ends, x goes back to x + 1
        let x = x * 2;
        println!("The value of x in the inner scope is: {x}");
    }

    println!("The value of x is: {x}");

    // floating-point types
    let w = 2.0; // f64 default type
    let y: f32 = 3.0; // f32 explicit type

    println!("The value of w is {} and the value of y is {}", w, y);

    // Some operations over numbers
    let sum = 5 + 10;
    let difference = 95.5 - 4.3;
    let product = 4 * 30;
    let quotient = 56.7 / 32.2;
    let truncated = -5 / 3;
    let remainder = 43 % 5;
    
    println!("Sum: {}, difference: {}, product: {}, quotient: {:.5}, truncated: {}, remainder: {}"
                    , sum, difference, product, quotient, truncated, remainder);

    // Char type
    let some_char = 'z';
    let another_char:char = 'Z'; // with explicit type annotation
    let heart_eyed_cat = '😻';

    println!("someChar: {some_char}, anotherChar: {another_char}, heart_eyed_cat: {heart_eyed_cat}");

    // Boolean types
    let t = true;
    let f:bool = false;
    println!("First we have t: {t}, second we have f: {f}");

    // compounds

    // tuples
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    // first way of accessing the values in a tuple
    let (x1, x2, x3) = tup;
    println!("The tuple tup: ({x1}, {x2}, {x3})");
    // second way of accessing the values in a tuple
    println!("The tuple tup is: ({}, {}, {})", tup.0, tup.1, tup.2);

    // arrays
    let my_array: [i32; 5] = [1, 2, 3, 4, 5];
    // initialize an array with k repeated n-times
    let another_array = [3; 5]; // [3, 3, 3, 3, 3]

    println!("my_array: [{}, {}, {}, {}, {}]", my_array[0], my_array[1], my_array[2], my_array[3], my_array[4]);
    println!("another_array: [{}, {}, {}, {}, {}]", another_array[0], another_array[1], another_array[2], another_array[3], another_array[4]);

    
    // Cambiar el tipo de dato de una variable
    let spaces = "    ";
    let spaces = spaces.len();

    println!("The amount of spaces is: {spaces}");

    println!("Three hours in seconds is: {THREE_HOURS_IN_SECONDS}");
}
