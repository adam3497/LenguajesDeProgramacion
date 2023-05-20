fn main() {
    let s = String::from("This is a sentece");
    let word = first_word(&s);

    println!("s: {}, and its first word: {}", s, word);

    let a = [1, 2, 3, 4, 5];
    let slice_a = &a[1..3];
    assert_eq!(slice_a, &[2, 3]);
}

// using &str instead of &String makes the function more general
fn first_word(s: &str) -> &str {
    // we create an array of bytes from s
    let bytes = s.as_bytes();

    // iter creates an iterator over the array of bytes
    // enumerate creates a tuple (a, &b) where a is the index and 
    // &b is the byte we are currently in 
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            // return the slice from 0 to i 
            return &s[..i];
        }
    }
    
    // return everything as a &str if there is not an space
    &s[..]
}
