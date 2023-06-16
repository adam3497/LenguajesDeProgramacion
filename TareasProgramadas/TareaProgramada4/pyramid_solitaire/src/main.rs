
// Enum para el tipo de carta: Clubs(Tréboles), Diamonds(Diamantes), Hearts(Corazones),
// Spades(Espadas)
#[derive(Debug, Copy, Clone)]
enum Suit {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
}

// Enum para el valor de la carta: Ace(1), 2 - 9, Z(10), Jack(11), Queen(12), King(13)
#[derive(Debug, Copy, Clone)]
enum Rank {
    Ace,
    Number(u8),
    Z,
    Jack,
    Queen,
    King,
}

// Struct que representa una carta con su tipo y valor
#[derive(Debug, Copy, Clone)]
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
            Rank::Number(8),
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
        use rand::seq::SliceRandom;
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
            let draw_first =  &self.draw_pile.first().unwrap();
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

                    None => print!("                     "),
                }
            }

            indent -= 2;
            println!();
        }
        println!();
    }

    /*
    Función que verifica si las dos cartas a las que se trata de hacer par suman 13.
    */
    fn is_pair(&self, card1: Card, card2: Card) -> bool {
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

    fn play(&mut self) {
        self.initialize();
        self.print_piles();
        self.print_pyramid();

        // Loop que permite jugar hasta que no se puedan hacer movimientos o el judador gane
        /* loop {
            let (row1, col1, row2, col2) = self.get_user_input();
            if row1.is_none() || col1.is_none() || row2.is_none() || col2.is_none() {
                println!("Game ended. Goodbye!");
                break;
            }

            let row1 = row1.unwrap();
            let col1 = col1.unwrap();
            let row2 = row2.unwrap();
            let col2 = col2.unwrap();

            let card1 = self.pyramid[row1][col1].unwrap();
            let card2 = self.pyramid[row2][col2].unwrap();

            if self.is_pair(card1, card2) {
                self.remove_pair(row1, col1, row2, col2);
                self.print_pyramid();
            } else {
                println!("No es una pareja válida, trata de nuevo!");
            }


        } */
    }

    /*
    Función para obtener las coordenadas 
    */
    /* fn get_user_input(&self) -> (Option()) {
        use std::io::{self, BufRead};

        println!("Introduzca las coordenadas de las dos cartas a remover (row1 col1 row2 col2), o 'quit' o 'q'  para salir:");
        println!("> ");
        
        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read input.");
        
        let input = input.trim().to_lowercase();

        if input == "quit" || input == "q" {
            return (None, None);
        }
        let stdin = io::stdin();
        let mut lines = stdin.lock().lines();

        let input = lines.next().unwrap().unwrap();
        let mut input_values = input.split_whitespace().map(|s| s.parse::<isize>().unwrap());

        let row1 = input_values.next().unwrap();
        let col1 = input_values.next().unwrap();
        let row2 = input_values.next().unwrap();
        let col2 = input_values.next().unwrap();

        if row1 == -1 || col1 == -1 || row2 == -1 || col2 == -1 {
            (None, None, None, None) // Quit the game
        } else {
            (
                Some(row1 as usize),
                Some(col1 as usize),
                Some(row2 as usize),
                Some(col2 as usize),
            )
        }
    } */
}



fn main() {
    let mut game = PyramidSolitaire::new();
    game.play();
}
