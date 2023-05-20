fn main() {
    /* 
    This string is being allocated in the heap rather than the stack
    this is cause the String does not have a known fixed size 
    */
    let mut s = String::from("Hello");
    s.push_str(", world!"); // push_str() appends a literal to a String
    println!("{}", s);

    // Variables and Data Interacting with Move
    let x = 5;
    let y = x; // here we are making a copy of the value in x and binding it to y.
    /*
    This happens since integers are simple values with a known fixed size 
    those two 5 values are pushed onto the stack
    */

    // But it's different when dealing with variables of unknown fixed size such as Strings
    let s1 = String::from("Hello");
    let s2 = s1; // move s1 into s2

    /*  
    A String is made up of 3 parts: pointer, length and capacity
    pointer -> a pointer to the memory that holds the content of the string
    length -> how much memory, in bytes, the contents of the string are currently using
    capacity -> total amount of memory, in bytes, recieved from the allocator.

    When we do let s2 = s1; we are copying the data that was stored onto the stack, which are 
    those 3 parts that that make up the String (pointer, length and capacity) and not its content.
    So now, we have two variables "pointing" to the same memory address with the same properties.

    The thing here is that after we do s2 = s1, Rust considers s1 as no longer valid, so we cannot 
    access it if we want to.

    println!("{}, world!", s1); would end up in a error 

    This process is called a **move**

    So at the end, we would say s1 was moved into s2, thus, making s1 no longer available after it.
    */

    /*
    If we want to copy the heap data of the String as well, not just the Stack data
    we can use a common method called clone()
    */
    let s3 = String::from("Hello");
    let s4 = s3.clone();

    // So now, s3 is also valid, and thus, it can be used just fine
    // Now s3 and s4 contains the same "Hello" String but in different heap memory addresses  
    println!("s3 = {}, s4 = {}", s3, s4);
    


}
