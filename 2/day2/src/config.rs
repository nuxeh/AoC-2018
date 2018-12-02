use docopt::Docopt;
use std::fs;
use std::path::PathBuf;

const USAGE: &str = "
Advent of code, day 2

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
pub struct RuntimeArgs {
    pub cli_args: CliArgs,
    pub input_file: PathBuf,
}

impl RuntimeArgs {
    pub fn get() -> Self {
        let mut args = RuntimeArgs::default();

        args.cli_args = Docopt::new(USAGE)
             .and_then(|d| d.deserialize())
             .unwrap_or_else(|e| e.exit());

        args.input_file = match args.cli_args.flag_test {
            true => PathBuf::from("test.txt"),
            false => PathBuf::from("input.txt")
        };

        if let Some(s) = args.clone().cli_args.arg_input {
            args.input_file = PathBuf::from(s);
        }

        args
    }
}
