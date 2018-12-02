extern crate docopt;
#[macro_use]
extern crate serde_derive;

use docopt::Docopt;
use std::fs;
use std::collections::HashMap;

const USAGE: &str = "
Advent of code, day 2

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test data
";

#[derive(Debug, Deserialize, Default)]
pub struct Args {
    flag_verbose: bool,
    flag_test: bool,
    arg_input: Option<String>,
}

fn main() {

    let args: Args = Docopt::new(USAGE)
                     .and_then(|d| d.deserialize())
                     .unwrap_or_else(|e| e.exit());

    let mut file = match args.flag_test {
        true => String::from("test.txt"),
        false => String::from("input.txt")
    };

    if let Some(s) = args.arg_input {
        file = String::from(s);
    }

    println!("[info] processing {}", file);

    let input = fs::read_to_string(file).unwrap_or(String::new());

    let mut doubles = 0;
    let mut triples = 0;

    for line in input.lines() {
        let hist = line
            .chars()
            .fold(HashMap::new(), |mut hist: HashMap<char, u32>, a| {
                if hist.contains_key(&a) {
                    let count = hist.get_mut(&a).unwrap();
                    *count += 1;
                } else {
                    hist.insert(a, 1);
                }
                hist
            });

        let vals: Vec<u32> = hist
            .values()
            .filter(|a| **a == 2 || **a == 3)
            .map(|a| *a)
            .collect();

        if vals.contains(&2) { doubles += 1; }
        if vals.contains(&3) { triples += 1; }

    }

    println!("doubles: {} triples: {}", doubles, triples);
    println!("checksum: {}", doubles * triples);

    println!("{:?}", input);

    // get an array of strings for the input
    let inputs: Vec<String> = input.lines().map(|a| String::from(a)).collect();

    println!("{:?}", inputs);

}
