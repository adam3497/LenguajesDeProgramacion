fn main() {
    let config_max = Some(3u8);
    match config_max {
        Some(max) => println!("The maximun is configured to be {}", max),
        _ => (), 
    }

    // we can do the same code above as follows
    if let Some(max) = config_max {
        println!("The maximun is configured to be {}", max);
    } // we could put an else statement here as well
}
