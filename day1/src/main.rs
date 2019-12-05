use itertools::iterate;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    println!(
        "{}",
        BufReader::new(File::open("input.txt").unwrap())
            .lines()
            .enumerate()
            .map(|(_i, line)| line.unwrap().parse::<i32>().unwrap())
            .map(|m| iterate(m, |&x| (x / 3) - 2)
                .take_while(|x| *x > 0)
                .skip(1)
                .sum::<i32>())
            .sum::<i32>()
    );
}
