use rand::Rng;
use std::{cmp::Ordering, io};

fn main() {
    println!("Guess the number!");

    // We generate a random number between 1 and 100 
    let secret_number = rand::thread_rng().gen_range(1..=100);

    // infinite loop until the user wins the game
    loop {
        println!("Please input your guess.");

        // We create a variable as a new String type
        let mut guess = String::new();

        // We get the user's input that if it's successful stores the value in the guess variable
        // if there's an error then it's catched with the expect() function
        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        // handling errors, we gotta remember the parse returns a result enum type with ok and err
        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("You must type a number!");
                continue;
            }
        };

        println!("You guessed: {guess}");

        // we use the in-built match function that compares two values
        // it returns an enum (Less, Greater, Equal) 
        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                // stops the loop when the user wins the game
                println!("You win!");
                break;
            }
        }
    }
}
