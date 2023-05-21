#[derive(Debug)]
enum UsState {
    Alabama,
    Alaska,
    Arizona,
    California,
    LosAngeles,
    NewYork,
    // --snip--
}

// coin enum
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

fn main() {
    let quarter_coin = Coin::Quarter(UsState::Alaska);
    let penny_coin = Coin::Penny;
    let nickel_coin = Coin::Nickel;
    let dime_coin = Coin::Dime;
    let quarter_value = value_in_cents(quarter_coin);
    let penny_value = value_in_cents(penny_coin);
    let nickel_value = value_in_cents(nickel_coin);
    let dime_value = value_in_cents(dime_coin);
    println!("Quarter coin value is: {}", quarter_value);
    println!("Nickel coin value is: {}", nickel_value);
    println!("Penny coin value is: {}", penny_value);
    println!("Dime coin value is: {}", dime_value);

    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);

    println!("Some five value is {:?}", five);
    println!("Some six value is {:?}", six);
    println!("none value is {:?}", none);

    let dice_roll = 9;
    match dice_roll {
        3 => {
            add_fancy_hat();
            move_player(3);
        },
        7 => {
            remove_fancy_hat();
            reroll();
        },
        _ => (),
    }

}

fn add_fancy_hat() {}
fn remove_fancy_hat() {}
fn move_player(_num_spaces: u8) {}
fn reroll() {}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        },
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        },
    }
}

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}