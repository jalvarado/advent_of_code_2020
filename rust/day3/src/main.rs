use std::fs::File;
use std::io::{BufReader, BufRead};

fn get_terrain(grid: &Vec<Vec<char>>, y: usize, x: usize) -> char {
    return grid[y][x % grid[y].len()]
}

fn count_trees(map: &Vec<Vec<char>>, delta_x: usize, delta_y: usize) -> u64 {
    let mut x = 0;
    let mut y = 0;
    let mut tree_count: u64 = 0;

    while y < map.len() {
        let terrain = get_terrain(&map, y, x);
        if terrain == '#' { tree_count += 1; }
        x += delta_x;
        y += delta_y;
    }

    return tree_count;
}

fn main() {
    let file = File::open("./input/input.txt").expect("no such file");
    let buf = BufReader::new(file);

    let map: Vec<Vec<char>> = buf
        .lines()
        .map(|l| l.expect("Could not parse line.").chars().collect::<Vec<char>>())
        .collect();

    // Part 1
    let trees_hit = count_trees(&map, 3, 1);
    println!("Slope ({}, {}) -- Trees Hit: {}", 3, 1, trees_hit);

    // Part 2
    let slopes = [
        [1,1],
        [3,1],
        [5,1],
        [7,1],
        [1,2],
    ];

    let total_trees: u64 = slopes.iter()
        .fold(1u64, |total, slope| { return total * count_trees(&map, slope[0], slope[1]); });
    println!("Total Trees hit: {}", total_trees);
}
