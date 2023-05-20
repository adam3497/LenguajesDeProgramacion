
// definition of a struct
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn main() {
    let mut user1 = User {
        active: true,
        username: String::from("someusername123"),
        email: String::from("someone@example.com"),
        sign_in_count: 1,
    };    

    user1.email = String::from("someone2@example2.com");

    println!("user1 -> active: {}, username: {}, email: {}, sign in count: {}", 
                user1.active, user1.username, user1.email, user1.sign_in_count);

    let user2 = build_user("someone3@example3.com".to_string(), 
                                "someone3".to_string());
    println!("user2 -> username: {}, email: {}", user2.username, user2.email);

    let user3 = User {
        email: "somebodyelse@example.com".to_string(),
        ..user1
    };

    println!("user3 -> username: {}, email: {}", user3.username, user3.email);
}

fn build_user(email: String, username: String) -> User {
    User {
        active: true,
        username,
        email,
        sign_in_count: 1
    }
}