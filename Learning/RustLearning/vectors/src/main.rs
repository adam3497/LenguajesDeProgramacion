fn main() {
    // creating a new empty vector
    let _v: Vec<i32> = Vec::new();

    // creating a new vector with the macro vec!
    let _v2 = vec![1, 2, 3];

    // creating a vector and adding elements to it
    let mut v3 = Vec::new();

    v3.push(2);
    v3.push(5);
    v3.push(6);
    v3.push(7);
    v3.push(8);

    // Reading elements of Vectors
    let v4 = vec![1, 2, 3, 4, 5];

    // first way is by using indexing
    let third: &i32 = &v4[2];
    println!("The third element is {}", third);

    // second way is by using the get() method and match
    let third: Option<&i32> = v4.get(2);
    match third {
        Some(third) => println!("The third element is {third}"),
        None => println!("There is no third element."),
    }

    // Accessing an element that does not exist
    let v5 = vec![1, 2, 3, 4, 5];

    // let does_not_exist_1 = &v[100]; // the programs panic
    let _does_not_exist = v5.get(100); // we can handle it with a match

    // Iterating over the values in a Vector (inmutable)
    let v6 = vec![100, 32, 57];

    for i in &v6 {
        println!("{i}");
    }

    // mutable
    let mut v7 = v6.clone();

    for i in &mut v7 {
        *i += 50;
    }

    println!("{:?}", v7);

    // Using enums
    #[derive(Debug)]
    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }

    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];

    println!("{:?}", row);
}
