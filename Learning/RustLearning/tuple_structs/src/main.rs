struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);

    println!("Color -> #{}{}{}", black.0, black.1, black.2);
    println!("Point -> x={}, y={}, z={}", origin.0, origin.1, origin.2);
}
