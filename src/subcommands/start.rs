use clap::{ArgMatches, SubCommand};

pub fn pack(c: SubCommand) {
	let args: ArgMatches = c.matches;
	// args 
	println!("Start {:?}", args);
}
