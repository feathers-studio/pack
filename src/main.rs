extern crate clap;

use clap::{App, Arg, SubCommand};
mod classifier;
mod subcommands;

fn main() {
	let matches = App::new("Pack")
		.version("1.0")
		.author("Muthu Kumar")
		.about("pack and move at a moment's notice")
		.subcommand(
			SubCommand::with_name("start")
				.arg(Arg::with_name("test").long("test"))
				.help("Generate Pack manifest"),
		)
		.subcommand(SubCommand::with_name("add").help("Add current path to Pack manifest"))
		.subcommand(
			SubCommand::with_name("up")
				.help("packages all the chosen paths and creates an archive"),
		)
		.subcommand(SubCommand::with_name("push").help("Push generated archive to location"))
		.get_matches();

	match matches.subcommand {
		Some(command) => classifier::init(*command),
		None => {
			// this case will never occur! Hopefully.
			println!("Command not found");
			std::process::exit(1);
		}
	}
}
