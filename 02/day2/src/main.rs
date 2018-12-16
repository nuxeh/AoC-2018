extern crate docopt;
#[macro_use]
extern crate serde_derive;

mod config;
use config::AoCRuntimeData;

use std::collections::HashMap;

fn main() {
    let data = AoCRuntimeData::get(2018, 2);

    let mut doubles = 0;
    let mut triples = 0;

    for line in data.string_data.lines() {
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

    for l in data.vector_data.clone() {
        for k in data.vector_data.clone() {
            let d = id_diff(&l, &k);
            if d == 1 {
                println!("{} {} {}", d, l, k);
                println!("{}", id_get_common(&l, &k));
            }
        }
    }
}

fn id_diff(a: &str, b: &str) -> u32 {
    a.chars()
        .zip(b.chars())
        .fold(0, |d, a| {
            if a.0 != a.1 {
                d + 1
            } else {
                d
            }
        })
}

fn id_get_common(a: &str, b: &str) -> String {
    a.chars()
        .zip(b.chars())
        .fold(String::new(), |mut c, a| {
            if a.0 == a.1 {
                c.push(a.0);
            }
            c
        })
}
