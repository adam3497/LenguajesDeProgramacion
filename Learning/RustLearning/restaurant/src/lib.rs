mod front_of_house;

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::deliver_order();
    }

    fn cook_order() {}

    // making a struct in a module
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }

    // making a enum in a module
    pub enum Appetizer {
        Soup,
        Salad,
    }
}

fn deliver_order() {}


mod costumer {
    pub use super::front_of_house::{hosting, serving};

    pub fn eat_at_restaurant() {
        // Absolute path
        crate::front_of_house::hosting::add_to_waitlist();
    
        // Relative path
        hosting::add_to_waitlist();
        serving::take_order();
    
        // Order a breakfast in the summer with Rye toast
        let mut meal = super::back_of_house::Breakfast::summer("Rye");
    
        // Change our mind about what bread we'd like
        meal.toast = String::from("Wheat");
        println!("I'd like {} toast please!", meal.toast);
    
        // meal.seasonal_fruit = String::from("blueberries"); would end up in an error
    
        // we can access all variants in the enum since it's public
        let order1 = super::back_of_house::Appetizer::Soup;
        let order2 = super::back_of_house::Appetizer::Salad;
    
    }
}



pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
