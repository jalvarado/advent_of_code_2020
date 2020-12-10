use std::fs::File;
use std::io::{BufRead,BufReader};

fn split_answer_groups(lines: Vec<String>) -> Vec<Vec<String>> {
    let mut grouped_answers: Vec<Vec<String>> = vec![];
    let mut answer_group: Vec<String> = vec![];
    for (index, answer) in lines.iter().enumerate() {
        if answer.is_empty() {
            grouped_answers.push(answer_group.clone());
            answer_group = vec![];
        } else {
            answer_group.push(answer.to_owned());
            if index == lines.len() - 1 { grouped_answers.push(answer_group.clone()); }
        }
    }

    return grouped_answers;
}

fn yes_answers_per_group(grouped_answers: Vec<Vec<String>>) -> Vec<Vec<u8>> {
    grouped_answers
        .iter()
        .map(|answer_group| {
            let mut answer_bytes: Vec<u8> = vec![];
            for answer_str in answer_group {
                for byte in answer_str.as_bytes() {
                    if !answer_bytes.contains(byte) {
                        answer_bytes.push(*byte);
                    }
                }
            }
            return answer_bytes;
        })
        .collect::<Vec<Vec<u8>>>()
}

fn main() {
    let file = File::open("input/input.txt").expect("No such file.");
    let buf = BufReader::new(file);

    let answers: Vec<String> = buf
        .lines()
        .map(|line| line.expect("Could not read line."))
        .collect();

    let grouped_answers = split_answer_groups(answers);
    let grouped_yes_answers = yes_answers_per_group(grouped_answers);

    let yes_count = grouped_yes_answers
        .iter()
        .fold(0, |acc, answer_group| acc + answer_group.len());

    println!("Count of yes answers: {}", yes_count);
}
