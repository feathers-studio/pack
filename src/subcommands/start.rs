use clap::{ArgMatches, SubCommand};
use dirs::home_dir;
use std::path::PathBuf;

pub fn pack(c: SubCommand) {
	let _args: ArgMatches = c.matches;
	let filename = format!(".{}_manifest", env!("CARGO_PKG_NAME"));
	if let Some(dir) = home_dir() {
		let manifest = get_manifest(dir, filename);
		println!("{:?}", manifest);
	}
}

fn get_manifest(dir: PathBuf, filename: String) -> PathBuf {
	let mut manifest_path = PathBuf::new();
	manifest_path.push(dir);
	manifest_path.push(filename);
	manifest_path
}
