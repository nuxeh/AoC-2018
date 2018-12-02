use docopt::Docopt;
use std::fs;
use std::path::PathBuf;

const USAGE: &str = "
Advent of code, day {{day}}

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test data
";

#[derive(Clone, Debug, Deserialize, Default)]
pub struct CliArgs {
    pub flag_verbose: bool,
    pub flag_test: bool,
    pub arg_input: Option<String>,
}

#[derive(Clone, Debug, Deserialize, Default)]
pub struct AoCRuntimeData {
    pub cli_args: CliArgs,
    pub input_file: PathBuf,
    pub string_data: String,
    pub vector_data: Vec<String>,
    pub verbose: bool,
}

impl AoCRuntimeData {
    pub fn get() -> Self {
        let mut data = AoCRuntimeData::default();

        data.cli_args = Docopt::new(USAGE)
             .and_then(|d| d.deserialize())
             .unwrap_or_else(|e| e.exit());

        data.input_file = match data.cli_args.flag_test {
            true => PathBuf::from("test.txt"),
            false => PathBuf::from("input.txt")
        };

        if let Some(s) = data.clone().cli_args.arg_input {
            data.input_file = PathBuf::from(s);
        }

        if data.cli_args.flag_verbose { data.verbose = true; }

        data.load_data();

        data
    }

    pub fn load_data(&mut self) {
        let s = fs::read_to_string(&self.input_file).unwrap_or(String::new());

        // set string data
        self.string_data = s.clone();

        // get an array of strings for the input
        self.vector_data = s.lines().map(|a| String::from(a)).collect();
    }
}
