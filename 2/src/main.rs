use std::fs::read_to_string;

fn interpreter(codes: Vec<usize>, pos: usize) -> Vec<usize> {
    let mut mutcodes = codes.clone();
    match codes[pos] {
        1 => {
            mutcodes[codes[pos + 3]] = codes[codes[pos + 1]] + codes[codes[pos + 2]];
        }
        2 => {
            mutcodes[codes[pos + 3]] = codes[codes[pos + 1]] * codes[codes[pos + 2]];
        }
        99 => return codes,
        _ => panic!("Bad input"),
    };

    interpreter(mutcodes, pos + 4)
}

fn brute_force(initial: Vec<usize>, ans: usize) -> Option<(usize, usize)> {
    for x in 0..99 {
        for y in 0..99 {
            let mut c = initial.clone();
            c[1] = x;
            c[2] = y;
            let v = interpreter(c, 0);
            // println!("{:?}", v);
            if v[0] == ans {
                return Some((x, y));
            }
        }
    }
    None
}
fn main() {
    let body: String = read_to_string("input.txt").unwrap().parse().unwrap();
    let input = body
        .trim()
        .split(",")
        .map(|x| x.parse::<usize>().unwrap())
        .collect();
    println!("{:?}", brute_force(input, 19690720));
}
