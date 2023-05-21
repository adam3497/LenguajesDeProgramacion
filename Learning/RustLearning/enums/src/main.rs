// definition of an enum
enum IpAddrKind {
    V4,
    V6,
}

enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

enum Message {
    Quit, 
    Move {x: i32, y: i32},
    Write(String),
    ChangeColor(i32, i32, i32),
}

impl Message {
    fn call(&self) {

    }
}

fn main() {
    // creating instances of our Enum IpAddrKind
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;

    route(&four);
    route(&six);

    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));

    let m = Message::Write(String::from("hello"));
    m.call();

    let some_number = Some(5);
    let some_char = Some('b');

    // Way of saying a 'Null' number  
    let absent_number: Option<i32> = None;

}

fn route(ip_kind: &IpAddrKind) {

}
