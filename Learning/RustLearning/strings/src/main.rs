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


}
