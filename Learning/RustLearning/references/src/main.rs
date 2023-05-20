fn main() {
    let s1 = String::from("Hello");

    // passing s1 as a references rather than moving s1 into the function
    let len = calculate_length(&s1);

    println!("The length of '{}', is {}.", s1, len);

    let mut s2 = String::from("Bye!");
    
    change(&mut s2);

    println!("s2 = {}", s2);
}

// This functions takes a references to a String and returns its length
fn calculate_length(s: &String) -> usize {
    s.len()
}

// This function takes a mutable reference String and modifies it
fn change(some_string: &mut String) {
    some_string.push_str(", bye!");
}