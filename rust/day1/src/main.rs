use std::io::Read;

fn main() {
    let mut file = std::fs::File::open("./input/input.txt").unwrap();

    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let numbers = contents
        .lines()
        .filter_map(|s| s.parse::<i32>().ok())
        .collect::<Vec<_>>();

    let mut pair: (i32, i32) = (0,0);
    let mut first_iter = numbers.iter();
    while let Some(first) = first_iter.next() {
        first_iter.clone().for_each(|second| {
            if first + second == 2020 {
                println!("Found pair summing to 2020: {}, {}", first, second);
                pair = (*first, *second);
            }
        });
    }

    let (first, second) = pair;
    println!("{}, {}: {}", first, second, first * second);
}
