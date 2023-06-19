use std::io::{stdin, Write, stdout};
use std::fs::{OpenOptions, File};
use termion::input::TermRead;
use termion::event::Key;
use termion::raw::IntoRawMode;
use rand::seq::SliceRandom;
use chrono::{Local, DateTime};

// Enum para el tipo de carta: Clubs(Tréboles), Diamonds(Diamantes), Hearts(Corazones),
// Spades(Espadas)
#[derive(Debug, Copy, Clone, PartialEq)]
enum Suit {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
}

// Enum para el valor de la carta: Ace(1), 2 - 9, Z(10), Jack(11), Queen(12), King(13)
#[derive(Debug, Copy, Clone, PartialEq)]
enum Rank {
    Ace,
    Number(u8),
    Z,
    Jack,
    Queen,
    King,
}

// Enum to handle the user input
#[derive(Debug, Copy, Clone)]
enum UserInput {
    Exit,
    NewGame,
    NewCard,
    Column(usize),
    Undo,
}

// Enum to handle the drawing of a card from the draw pile
#[derive(Debug, Clone)]
enum DrawResult {
    Drawn(String),
}

#[derive(Debug, Clone)]
enum MoveResult {
    ValidMove(String),
}

// Struct que representa una carta con su tipo y valor
#[derive(Debug, Copy, Clone, PartialEq)]
struct Card {
    suit: Suit,
    rank: Rank,
}

impl Card {
    // Función interna del struct que permite crear una nueva carta
    fn new(suit: Suit, rank: Rank) -> Card {
        Card { suit, rank }
    }
}

// Struct para la pirámide y las dos pilas (Reserva y basurero)
struct PyramidSolitaire {
    pyramid: Vec<Vec<Option<Card>>>,
    draw_pile: Vec<Card>,
    waste_pile: Vec<Card>,
    success_pile: Vec<Card>,
}

impl PyramidSolitaire {
    // Permite crear las estructuras para contener las cartas
    fn new() -> PyramidSolitaire {
        PyramidSolitaire { 
            pyramid: vec![], 
            draw_pile: vec![], 
            waste_pile: vec![],
            success_pile: vec![],
        }
    }

    /*
    Función para inicializar la baraja de cartas con las 52 cartas las cuales se descomponen en 
    4 palos y 13 valores diferentes. Además, crea el layout de la pirámide.
    */
    fn initialize(&mut self) {
        // Una lista con los 4 tipos de palos
        let suits = [
            Suit::Clubs,
            Suit::Diamonds,
            Suit::Hearts,
            Suit::Spades,
        ];

        // Lista con los valores para las cartas
        let ranks = [
            Rank::Ace,
            Rank::Number(2),
            Rank::Number(3),
            Rank::Number(4),
            Rank::Number(5),
            Rank::Number(6),
            Rank::Number(7),
            Rank::Number(8),
            Rank::Number(9),
            Rank::Z,
            Rank::Jack,
            Rank::Queen,
            Rank::King
        ];

        // Creamos el deck de cartas y agregamos las 52 cartas
        // con 4 tipos y 13 valores diferentes por tipo
        let mut cards = Vec::new();

        for suit in &suits {
            for rank in &ranks {
                cards.push(Card::new(*suit, *rank));
            }
        }

        // Barajamos las cartas
        let mut rng = rand::thread_rng();
        cards.shuffle(&mut rng);

        // Creamos el layout de la pirámide
        let mut pyramid = Vec::new();
        let mut index = 0;

        for row in 0..7 {
            pyramid.push(Vec::new());
            for _ in 0..=row {
                pyramid[row].push(Some(cards[index]));
                index += 1;
            }
        }

        // Pasamos las estructuras inicializadas a las variables del struct
        self.pyramid = pyramid;
        self.draw_pile = cards[index..].to_vec();

    }

    /*
    This function takes the rank of a card struct and returns its string value
    representation.
    */
    fn get_rank_string(&self, card_rank: &Rank) -> String {
        match card_rank {
            Rank::Ace => String::from("A"),
            Rank::Number(num) => num.to_string(),
            Rank::Z => String::from("Z"),
            Rank::Jack => String::from("J"),
            Rank::Queen => String::from("Q"),
            Rank::King => String::from("K"),
        }
    }

    /*
    This functions matches the suit of a card struct and returns its string value
    representation. 
    */
    fn get_suit_string(&self, card_suit: &Suit) -> String {
        match card_suit {
            Suit::Clubs => String::from("T"),
            Suit::Diamonds => String::from("D"),
            Suit::Hearts => String::from("C"),
            Suit::Spades => String::from("E"),
        }
    }

    /*
    This function takes the suit of a card struct and returns its string color 
    representation depending on its suit.
    */
    fn get_color_string(&self, card_suit: &Suit) -> String {
        match card_suit {
            Suit::Clubs | Suit::Spades => String::from("n"),
            Suit::Hearts | Suit::Diamonds => String::from("r"),
        }
    }

    /*
    This function prints the draw, waste and success piles in the screen, above the pyramid.
    */
    fn print_piles(&self) {
        println!();
        if self.draw_pile.len() == 0 {
            print!("Draw pile: ___");
        } else {
            let draw_first =  &self.draw_pile.last().unwrap();
            let draw_rank = self.get_rank_string(&draw_first.rank);
            let draw_suit = self.get_suit_string(&draw_first.suit);
            let draw_color = self.get_color_string(&draw_first.suit);

            print!("Draw pile: {draw_rank}{draw_suit}{draw_color}");
        }
        
        print!(" | ");
        if self.waste_pile.len() == 0 {
            print!("Waste pile: ___");
        } else {
            let top_waste = &self.waste_pile.last().unwrap();
            let waste_rank = self.get_rank_string(&top_waste.rank);
            let waste_suit = self.get_suit_string(&top_waste.suit);
            let waste_color = self.get_color_string(&top_waste.suit);
            
            print!("Waste pile: {waste_rank}{waste_suit}{waste_color}");
        }
        
        // Print some spaces between the draw/waste piles and the success pile
        let indent = self.pyramid.len() * 4;
        for _ in 0..indent {
            print!(" ");
        }
        
        if self.success_pile.len() == 0 {
            print!("Success pile: ___");
        } else {
            let top_success = &self.success_pile.last().unwrap();
            let success_rank = &self.get_rank_string(&top_success.rank);
            let success_suit = &self.get_suit_string(&top_success.suit);
            let success_color = &self.get_color_string(&top_success.suit);

            print!("Success pile: {success_rank}{success_suit}{success_color}");
        }
        println!();
    }

    /*
    Función para imprimir la pirámide en pantalla
    */
    fn print_pyramid(&self) {
        println!();
        let mut indent = self.pyramid.len() * 6;

        for row in &self.pyramid {
            for _ in 0..indent {
                print!(" ");
            }
            for card in row {
                match card {
                    Some(card) => {
                        let rank = self.get_rank_string(&card.rank);
                        let suit = self.get_suit_string(&card.suit);
                        let color = self.get_color_string(&card.suit);

                        print!("{rank}{suit}{color}  ", rank = rank, suit = suit, color = color);
                    }
                    None => print!("___  "),
                }
            }
            indent -= 2;
            println!();
        }
        println!();
    }

    /*
    Función que verifica si las dos cartas seleccionadas suman 13.
    */
    fn is_pair(&self, card1: &Card, card2: &Card) -> bool {
        let rank_rum = match card1.rank {
            Rank::Ace => 1,
            Rank::Number(num) => num as u8,
            Rank::Z => 10,
            Rank::Jack => 11,
            Rank::Queen => 12,
            Rank::King => 13,
        };

        rank_rum + match card2.rank {
            Rank::Ace => 1,
            Rank::Number(num) => num as u8,
            Rank::Z => 10,
            Rank::Jack => 11,
            Rank::Queen => 12,
            Rank::King => 13,
        } == 13
    }

    /*
    Función para remover un par de cartas suman 13
    */
    fn remove_pair(&mut self, row1: usize, col1: usize, row2: usize, col2: usize) {
        self.pyramid[row1][col1] = None;
        self.pyramid[row2][col2] = None;
    }

    /* */
    fn remove_card_pyramid(&mut self, row: usize, col: usize) {
        self.pyramid[row][col] = None;
    }

    /*
    Function to draw a new card. It checks whether the draw pile has cards available
    If so then an Ok result is return, if not an Err result is return.
    */
    fn draw_new_card(&mut self) -> Result<DrawResult, String>{
        if self.draw_pile.len() > 0 {
            // Take the last element of the draw pile and remove it from the pile
            let draw_top = self.draw_pile.pop().unwrap();
            // Check if the card is a King, if so, move it to the success pile
            if draw_top.rank == Rank::King {
                self.success_pile.push(draw_top);
                return Ok(DrawResult::Drawn(String::from("Card was a King")));
            }
            // If the card is not a King, push the card into the waste pile 
            self.waste_pile.push(draw_top);
            return Ok(DrawResult::Drawn(String::from("New card drawn")));
            
        } else {
            // If there are no more cards, we put the cards in the waste pile back into the draw pile
            if self.waste_pile.len() > 0 {
                while self.waste_pile.len() > 0 {
                    self.draw_pile.push(self.waste_pile.pop().unwrap());
                }
                return Ok(DrawResult::Drawn(String::from("Waste pile was put back into draw pile")));
            } else {
                return Err(String::from("No more cards left to draw"));
            }
        }
        
    }

    /* This function verifies if a card inside the pyramid is available to play with. This means, that
    there are no other cards 'on top' of it or covering it. To do so, we gotta check that the position
    in the next row and position + 1 in the next row are free, that means, there are no cards on those
    positions. This only works for rows from 0 to 5. Row 6 is the last row in the pyramid and is always
    available */
    fn is_valid_card(&self, row: &usize, column: &usize) -> bool {
        // The card is in the last row (always available)
        if *row == 6 {
            return true;
        }

        // The card is not in the last row, so we need to check its neighbors 
        //(pos and pos+1 in the next row)
        if self.pyramid[row+1][*column] == None && self.pyramid[row+1][column+1] == None {
            return true;
        }
        // The cards is not available to play 
        false 
    }

    /* */
    fn get_card_from_pyramid(&self, column: &usize) -> Option<(usize, usize)> {
        // Iterate through the pyramid checking every row in the specified column
        // If the pyramid[i][column] is a valid card to play, then its position Some((i, column))
        // is returned. If we reach the end and nothing was found a None is returned.
        for i in (0..=self.pyramid.len()-1).rev() {
            dbg!("{}", self.pyramid[i].len());
            dbg!("{:?}", &self.pyramid[i]);
            if *column < self.pyramid[i].len() {
                if self.pyramid[i][*column] != None && self.is_valid_card(&i, column) {
                    return Some((i, *column));
                }
            }
        }
        None
    }

    /* */
    fn pair_against_pyramid(&self, row1: &usize, col1: &usize) -> Option<(usize, usize)> {
        // Iterate through all the rows of the pyramid in reverse (starting in the last row)
        for row2 in (0..=self.pyramid.len()-1).rev() {
            // Iterate through all the columns of the current row i
            for col2 in 0..=self.pyramid[row2].len()-1 {
                // Skip the card we selected
                if *row1 == row2 && *col1 == col2 {
                    continue;
                }
                // Verify if the current card is available
                if self.pyramid[row2][col2] != None && self.is_valid_card(&row2, &col2) {
                    let card1 = &self.pyramid[*row1][*col1].unwrap();
                    let card2 = &self.pyramid[row2][col2].unwrap();
                    // Verify if both cards are a valid pair
                    if self.is_pair(card1, card2) {
                        // The current card2 is a valid match for the card1
                        return Some((row2, col2));
                    }
                }
            }
        }
        // There are no valid matches
        None
    }

    /* */
    fn make_a_move(&mut self, column: &usize) -> Result<MoveResult, String>{
        // Get the card from the pyramid, if there's a valid card on the specified column, then we
        // proceed to try to make a move, if not then we return a no move action 
        match self.get_card_from_pyramid(column) {
            // We retrieve the card from the pyramid, only if it's a valid card to play
            Some((row1, col1)) => {
                // Check if the card is a king, if so, we move it to the success pile
                if self.pyramid[row1][col1].unwrap().rank == Rank::King {
                    let card = self.pyramid[row1][col1].unwrap().clone();
                    self.success_pile.push(card);
                    self.remove_card_pyramid(row1, col1);
                    return Ok(MoveResult::ValidMove(String::from("Card was a king")));
                }

                // if a valid card is found inside the pyramid, then we proceed to verify for a move
                // First we check if there's a valid pair inside the pyramid with the card selected
                match self.pair_against_pyramid(&row1, &col1) {
                    // If there's a valid pair, the card's coordinates are returned
                    Some((row2, col2)) => {
                        let card1 = self.pyramid[row1][col1].unwrap().clone();
                        let card2 = self.pyramid[row2][col2].unwrap().clone();
                        // push the cards into the success pile
                        self.success_pile.push(card1);
                        self.success_pile.push(card2);
                        // remove both cards from the pyramid
                        self.remove_pair(row1, col1, row2, col2);
                        
                        return Ok(MoveResult::ValidMove(String::from("Pair in pyramid")));
                    }
                    // There was no move within the pyramid
                    None => {
                        // reference to the selected card
                        let selected_card = &self.pyramid[row1][col1].unwrap();
                        
                        // Proceed to compare the selected card against the top card of the 
                        // draw pile
                        if self.draw_pile.len() > 0 {
                            let top_draw_pile = self.draw_pile.last().unwrap();
                            if self.is_pair(selected_card, top_draw_pile) {
                                // If they are a valid pair then
                                // Push the card to the success pile
                                self.success_pile.push(selected_card.clone());
                                self.success_pile.push(self.draw_pile.pop().unwrap());
                                // remove the card from the pyramid
                                self.remove_card_pyramid(row1, col1);
                                
                                return Ok(MoveResult::ValidMove(String::from("Pair with draw pile")));
                            }
                        }
                        // And if there's no pair against the draw pile, then we compare against the
                        // waste pile
                        if self.waste_pile.len() > 0 {
                            let top_waste_pile = self.waste_pile.last().unwrap();
                            if self.is_pair(selected_card, top_waste_pile) {
                                // if they are a valid pair then, push the cards to the success pile
                                self.success_pile.push(selected_card.clone());
                                self.success_pile.push(self.waste_pile.pop().unwrap());

                                // remove the selected card from the pyramid
                                self.remove_card_pyramid(row1, col1);
                                
                                return Ok(MoveResult::ValidMove(String::from("Pair with waste pile")));
                            }
                        }
                        
                        // There are no valid moves for the selected card
                        return Err(String::from("No valid move"));

                    }
                }
            }
            None => {
                // Could not find a valid card to select from the pyramid
                return Err(String::from("No valid card"));
            }
        }
    }

    /* This function verifies if there are no more cards in the pyramid, if so, the player
    wins and a true is returned, if there are still cards then a false is returned */
    fn check_for_win(&self) -> bool {
        for i in (0..=self.pyramid.len()-1).rev() {
            for j in 0..=self.pyramid[i].len()-1 {
                if self.pyramid[i][j] != None {
                    return false;
                }
            }
        }
        true
    }

    /* */
    fn get_card_representation(&self, card: &Card) -> String {
        let rank = self.get_rank_string(&card.rank);
        let suit = self.get_suit_string(&card.suit);
        let color = self.get_color_string(&card.suit);
        return format!("{rank}{suit}{color}")
    }

    /* This function writes into the log file all the game state (pyramid and piles) */
    fn write_game_state(&self, file: &mut File) {
        if self.draw_pile.len() > 0 {
            let draw_top = self.draw_pile.last().unwrap();
            let draw_rep = self.get_card_representation(draw_top);
            write!(file, "Draw pile: {} | ", draw_rep).unwrap();
        } else {
            write!(file, "Draw pile: ___ | ").unwrap();
        }

        if self.waste_pile.len() > 0 {
            let waste_top = self.waste_pile.last().unwrap();
            let waste_rep = self.get_card_representation(waste_top);
            write!(file, "Waste pile: {} | ", waste_rep).unwrap();
        } else {
            write!(file, "Waste pile: ___ | ").unwrap();
        }

        if self.success_pile.len() > 0 {
            let success_top = self.success_pile.last().unwrap();
            let success_rep = self.get_card_representation(success_top);
            write!(file, "Success pile: {}", success_rep).unwrap();
        } else {
            write!(file, "Success pile: ___ | ").unwrap();
        }

        writeln!(file).unwrap();
        writeln!(file, "Pyramid state").unwrap();

        for i in 0..=self.pyramid.len()-1 {
            for j in 0..=self.pyramid[i].len()-1 {
                if self.pyramid[i][j] == None {
                    write!(file, " ___ ").unwrap();
                    continue;
                }
                let current_card = &self.pyramid[i][j].unwrap();
                let card_rep = self.get_card_representation(current_card);
                write!(file, " {} ", card_rep).unwrap();
            }
            writeln!(file).unwrap();
        }
        
    }


    /* Function to write the current date and time into the log file */
    fn write_log_entry(&self, file: &mut File) {
        let now: DateTime<Local> = Local::now();
        let formatted_date = now.format("%d-%b-%Y").to_string();
        let formatted_time = now.format("%l:%M %P").to_string();
        writeln!(file, "[ log entry ] [ {} {} ]", formatted_date, formatted_time).unwrap();
    }

    /* */
    fn write_separator(&self, file: &mut File) {
        write!(file, "{}", std::iter::repeat("-").take(60).collect::<String>()).unwrap();
        writeln!(file).unwrap();
    }

    /* This function writes to the log file when a player creates a new game.
    It also saves the state of that new game */
    fn save_to_log_new_game(&self) -> std::io::Result<()>{
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open("game_log.txt")?;
        self.write_log_entry(&mut file);
        writeln!(file, "Player creates a new game.").unwrap();
        writeln!(file, "New game has the following state: ").unwrap();
        self.write_game_state(&mut file);
        self.write_separator(&mut file);
        Ok(())
    }

    /* This function saves to a log when a player exists the game */
    fn save_to_log_exit(&self) -> std::io::Result<()>{
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open("game_log.txt")?;
        self.write_log_entry(&mut file);
        writeln!(file, "Player exists the game.").unwrap();
        self.write_game_state(&mut file);
        self.write_separator(&mut file);
        Ok(())
    }

    /* */
    fn save_to_log_draw(&self) {
        
    }

}

/*
Función para obtener la entrada desde el teclado del usuario.
*/
fn get_user_input() -> Result<UserInput, String> {
    println!("What would you like to do?");
    println!("Options: \n> ESC key -> Exit game.\n> n/N -> New game.\n> <column #> (1, 2, 3, 4, 5, 6, 7) -> Select a column.\n> u/U -> Undo move.");

    let stdin = stdin();
    // setting up stdout and going into raw mode
    let mut stdout = stdout().into_raw_mode().unwrap();
    // printing the indicator message for input 
    write!(stdout, r#"> "#).unwrap();
    stdout.flush().unwrap();

    // detecting keydown events
    for c in stdin.keys() {
        // Match the key event
        match c.unwrap() {
            Key::Esc => return Ok(UserInput::Exit),
            Key::Char('n') | Key::Char('N') => return Ok(UserInput::NewGame),
            Key::Char('\n') => return Ok(UserInput::NewCard),
            Key::Char('1') => return Ok(UserInput::Column(1)), 
            Key::Char('2') => return Ok(UserInput::Column(2)), 
            Key::Char('3') => return Ok(UserInput::Column(3)), 
            Key::Char('4') => return Ok(UserInput::Column(4)), 
            Key::Char('5') => return Ok(UserInput::Column(5)), 
            Key::Char('6') => return Ok(UserInput::Column(6)), 
            Key::Char('7') => return Ok(UserInput::Column(7)),
            Key::Char('u') | Key::Char('U') => return Ok(UserInput::Undo),
            _ => return Err(String::from("Invalid input")),
        }
    }

    Err(String::from("Couldn't detect any key"))
}

/* Function to clear the terminal. */
fn clear_terminal() {
    let mut stdout = stdout().into_raw_mode().unwrap();
    write!(stdout, r#"{}"#, termion::clear::All).unwrap();
    stdout.flush().unwrap();
} 

/* This function creates a new instance of a pyramid solitaire game. It calls the methods to
initialize all the corresponding vectors, clear the terminal and print the piles and pyramid */
fn new_game() -> PyramidSolitaire {
    // create and shuffle the deck
    let mut game = PyramidSolitaire::new();
    game.initialize();
    clear_terminal();
    game.print_piles();
    game.print_pyramid();
    //TODO: separate the functionality to shuffle and create the pyramid inside initialize() function
    game
}

/* In this function the game logic is handle. It asks for the input from the player and depending
on the context makes the corresponding move or indicates to the user that there's no move. It also 
calls to the corresponding function to verify whether a pair is a valid pair (both sum up to 13) or 
the not. */
fn play() {
    // create a new instance of a game
    let mut game_state = new_game();

    // Main loop to control the game until the user exits the game
    // If the user wins, then they can decide whether they want to continue with a new game
    // or simply exit the game.
    loop {
        let user_input = get_user_input();
        match user_input {
            Ok(input) => {
                match input {
                    UserInput::Exit => {
                        game_state.save_to_log_exit().unwrap();
                        println!("Thanks for playing, game ended!");
                        break;
                    }
                    UserInput::NewGame => {
                        println!("Creating a new game!");
                        // create a new instance of a game
                        game_state = new_game();
                        game_state.save_to_log_new_game().unwrap();
                    }
                    UserInput::NewCard => {
                        // To drawn a new card, the function to do so is called and if the
                        // operation was successful then an Ok(DrawResult::Drawn) is received
                        println!("Drawing a new card...");
                        match game_state.draw_new_card() {
                            Ok(DrawResult::Drawn(msg)) => {
                                // print the piles and pyramid again
                                // and clearing the terminal
                                clear_terminal();
                                println!("{}", msg);
                                game_state.print_piles();
                                game_state.print_pyramid();
                            }
                            Err(msg) => {
                                clear_terminal();
                                println!("{msg}");
                                game_state.print_piles();
                                game_state.print_pyramid();
                            }
                        }
                    }
                    UserInput::Column(column) => {
                        println!("Selected column: {}", column);
                        // Update the column value to work from 0 to 6
                        let column = column-1;
                        match game_state.make_a_move(&column) {
                            Ok(MoveResult::ValidMove(msg)) => {
                                // There was a valid move, so we proceed to update the game 
                                clear_terminal();
                                // Check if the player won
                                if game_state.check_for_win() {
                                    println!("You win! :D");
                                }
                                println!("{}", msg);
                                game_state.print_piles();
                                game_state.print_pyramid();
                            }
                            Err(msg) => {
                                // There was no valid move, but we update the game anyways
                                clear_terminal();
                                println!("{}", msg);
                                game_state.print_piles();
                                game_state.print_pyramid();
                            }
                        }
                    }
                    UserInput::Undo => println!("Undoing move..."),
                }
            }
            Err(error) => {
                clear_terminal();
                println!("{}", error);
                println!("Try again! ;)");
                game_state.print_piles();
                game_state.print_pyramid();
                
            }
        }
    }
}

fn main() {
    play();
}
