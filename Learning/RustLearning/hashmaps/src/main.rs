use std::collections::HashMap;

fn main() {
    // creating a new hashmap
    let mut scores = HashMap::new();

    // inserting some data
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    // accesing values
    let team_name = String::from("Blue");
    // we use copied() to get an Option<i32> rather than Option<&i32>
    // and with unwrap_or() to set the score to zero if scores doesn't have an entry for the key
    let score = scores.get(&team_name).copied().unwrap_or(0);
    println!("The score for the {team_name} team is {score}");

    // iterate over each key/value
    for (key, value) in &scores {
        println!("{key} : {value}");
    }

    // for types that implement the copy trait, the values are copied into the hashmap 
    // for owned values like Strings, the values will be moved and the hash map will be the owner

    let field_name = String::from("Favorite color");
    let field_value = String::from("Blue");

    let mut map = HashMap::new();
    map.insert(field_name, field_value);
    // field_name and field_value are invalid at this point, cause the hash map took ownership 
    // over them

    // overwriting a value
    scores.insert(String::from("Blue"), 25);
    println!("{:?}", scores);

    // adding a key and a value, only if the key isn't present 
    scores.entry(String::from("Yellow")).or_insert(50);
    scores.entry(String::from("Blue")).or_insert(50);
    scores.entry(String::from("Red")).or_insert(50);

    println!("{:?}", scores);

    // updating a value based on the old value
    let text = "hello world wonderful world";

    let mut map1 = HashMap::new();

    // The split_whitespace method returns an iterator over sub-slices, separated by whitespace
    // the or_insert() method returns a mutable reference (&mut v) to the value for the key
    for word in text.split_whitespace() {
        let count = map1.entry(word).or_insert(0);
        // we first dereference count (*) to assign a value
        *count += 1;
    }

    println!("{:?}", map1);
}
