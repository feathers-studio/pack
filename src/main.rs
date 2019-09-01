extern crate clap;
mod commands;

use clap::{App, Arg, SubCommand};
// use commands::p

fn main() {
	let matches = App::new("Pack")
		.version("1.0")
		.author("Muthu Kumar")
		.about("pack and move at a moment's notice")
		.subcommand(SubCommand::with_name("start").arg(
			Arg::with_name("test")
		).help("Generate Pack manifest"))
		.subcommand(SubCommand::with_name("add").help("Add current path to Pack manifest"))
		.subcommand(
			SubCommand::with_name("up")
				.help("packages all the chosen paths and creates an archive"),
		)
		.subcommand(SubCommand::with_name("push").help("Push generated archive to location"))
		.get_matches();

	println!("{:?}", matches.args);
	if let Some(command) = matches.subcommand {
		match command.name.as_ref() {
			"start" => commands::start::pack(),
			_ => println!("Command not found"),
		}
	}
}
