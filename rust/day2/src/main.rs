use std::fs::File;
use std::io::BufRead;
use std::io::BufReader;
use regex::Regex;

fn valid_password(password_line: &str) -> bool {
    let regex = Regex::new(r"(\d+)-(\d+) ([a-z]): ([a-z]*)").unwrap();
    let caps = regex.captures(password_line).unwrap();
    let min: i32 = caps.get(1).map_or(-1, |m| m.as_str().parse::<i32>().unwrap());
    let max: i32 = caps.get(2).map_or(-1, |m| m.as_str().parse::<i32>().unwrap());
    let c: &str = caps.get(3).map_or("", |m| m.as_str());
    let password: &str = caps.get(4).map_or("", |m| m.as_str());
    let count = password.matches(c).count();

    return count >= min as usize && count <= max as usize
}

fn main() {
    let file = File::open("./input/input.txt").expect("no such file");
    let buf = BufReader::new(file);

    let lines: Vec<String> = buf
        .lines()
        .map(|l| l.expect("Could not parse line."))
        .collect();

    let v_count = lines.iter()
        .map(|line| valid_password(line))
        .map(|valid| {
            if valid { return 1u32 } else { return 0u32 };
        })
        .sum::<u32>();
    println!("Valid password count using sum: {}", v_count)
}
