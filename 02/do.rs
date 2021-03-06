use std::fs;
use std::collections::HashMap;

fn main() {
    let input = fs::read_to_string("input.txt").unwrap_or(String::new());

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
}
