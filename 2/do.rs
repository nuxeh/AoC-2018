use std::fs;

fn main() {
    let input = fs::read_to_string("input.txt").unwrap_or(String::new());
    for line in input.lines() {
        println!("{}", line);
    }
}
