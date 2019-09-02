use crate::subcommands;
use clap::SubCommand;

pub fn init(c: SubCommand) {
	match c.name.as_ref() {
		"start" => subcommands::start::pack(c),
		_ => println!("Command not found"),
	}
}
