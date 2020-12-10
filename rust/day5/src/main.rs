use std::fs::File;
use std::io::{BufRead,BufReader};
use std::cmp::Ordering;

#[derive(Debug,Default)]
struct BoardingPass {
    row: i32,
    seat: i32,
}

impl BoardingPass {
    fn seat_id(&self) -> i32 {
        self.row * 8 + self.seat
    }
}

impl Ord for BoardingPass {
    fn cmp(&self, other: &Self) -> Ordering {
        self.seat_id().cmp(&other.seat_id())
    }

}

impl PartialOrd for BoardingPass {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for BoardingPass {
    fn eq(&self, other: &Self) -> bool {
        self.seat_id() == other.seat_id()
    }
}

impl Eq for BoardingPass {}

fn decode_row(row_encoding: &str, mut row_range: Vec<i32>) -> i32 {
    if row_range.len() == 1 || row_encoding.is_empty() {
        return row_range[0];
    };

    let enc: u8 = row_encoding.as_bytes()[0];

    if enc == b'F' {
        row_range = row_range[0..row_range.len()/2].to_vec();
    } else if enc == b'B' {
        row_range = row_range[row_range.len()/2..row_range.len()].to_vec();
    }

    return decode_row(&row_encoding[1..], row_range)
}

fn decode_seat(seat_encoding: &str, mut seat_range: Vec<i32>) -> i32 {
    if seat_range.len() == 1 { return seat_range[0]; };

    let enc: u8 = seat_encoding.as_bytes()[0];

    if enc == b'L' {
        seat_range = seat_range[0..seat_range.len() / 2].to_vec();
    } else if enc == b'R' {
        seat_range = seat_range[seat_range.len() / 2..seat_range.len()].to_vec();
    }

    return decode_seat(&seat_encoding[1..], seat_range)
}

fn decode_boarding_pass_string(boarding_pass_str: &str) -> BoardingPass {
    let mut boarding_pass = BoardingPass::default();

    // Calculate the row number
    let row_encoding = boarding_pass_str[0..7].to_owned();
    boarding_pass.row = decode_row(&row_encoding, (0..128).collect());

    // Calculate the seat number
    let seat_encoding = boarding_pass_str[7..].to_owned();
    boarding_pass.seat = decode_seat(&seat_encoding, (0..8).collect());

    return boarding_pass;
}

fn get_max_seat_id(boarding_passes: &Vec<String>) -> i32 {
    let passes: Vec<BoardingPass> = boarding_passes
        .iter()
        .map(|pass_str| decode_boarding_pass_string(&pass_str))
        .collect();

    let max_by_seat_id = passes
        .iter()
        .max()
        .unwrap();

    return max_by_seat_id.seat_id();
}

fn find_my_seat(boarding_passes: &Vec<BoardingPass>) -> i32 {
    let mut seat_ids: Vec<i32> = boarding_passes
        .iter()
        .map(|pass| pass.seat_id())
        .collect();
    seat_ids.sort();

    let min_id = seat_ids.iter().min().unwrap();

    for (index, seat_id) in seat_ids.iter().enumerate() {
        if !(*seat_id == (min_id + index as i32)) { return min_id + index as i32 }
    }

    return 0;
}

fn main() {
    let file = File::open("input/input.txt").expect("No such file.");
    let buf = BufReader::new(file);

    let boarding_passes: Vec<String> = buf
        .lines()
        .map(|line| line.expect("Could not parse line into String"))
        .collect();

    let max_seat_id = get_max_seat_id(&boarding_passes);
    println!("Max seat id = {}", max_seat_id);

    /* Part Two */
    let passes: Vec<BoardingPass> = boarding_passes
        .iter()
        .map(|pass_str| decode_boarding_pass_string(pass_str))
        .collect();

    let my_seat_id = find_my_seat(&passes);
    println!("My seat id = {}", my_seat_id);
}
