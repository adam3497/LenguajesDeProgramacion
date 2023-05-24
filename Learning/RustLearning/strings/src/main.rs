fn main() {
    // creating an instance of a String (empty String)
    let mut _s = String::new();

    // initial data to initialize the String variable
    let data = "Initial contents";
    let _s = data.to_string();
    let _s = "Initial contents".to_string();
    let _s = String::from("Initial contents");

    // Updating a String

    // appending with push_str and push
    let mut s1 = String::from("foo");
    let s2 = "bar";
    s1.push_str(s2);
    println!("s2 is {s2}");

    let mut s = String::from("lo");
    s.push('l');
    println!("{s}");

    // concatenation with the + Operator or the format! macro
    let s1 = String::from("Hello, ");
    let s2 = String::from("world!");
    let s3 = s1 + &s2; // note s1 has been moved here and can no longer be used

    println!("s1 + s2 = {s3}");

    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s3 = String::from("toe");

    let s = format!("{s1}-{s2}-{s3}");
    println!("s = {s}");

    // Iterating over String
    // using chars to get each individual character (notice here each character takes 2 bytes)
    for c in "Зд".chars() {
        println!("{c}");
    }

    // bytes method returns each raw byte 
    for b in "Зд".bytes() {
        println!("{b}");
    }
}
