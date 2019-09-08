use clap::{ArgMatches, SubCommand};
use dirs::home_dir;
use std::path::PathBuf;
use std::fs::File;
use std::io::Read;

pub fn pack(c: SubCommand) {
	let _args: ArgMatches = c.matches;
	let filename = format!(".{}_manifest", env!("CARGO_PKG_NAME"));
	if let Some(dir) = home_dir() {
		let manifest = get_manifest(dir, filename);
		if !manifest.exists() {
			let _file = File::create(manifest.as_path());
		} else {
			let res = File::open(manifest.as_path());
			let mut file = res.unwrap();
			let mut content = String::new();
			file.read_to_string(&mut content).unwrap();
			println!("file content {}", content);
		}

	}
}

fn get_manifest(dir: PathBuf, filename: String) -> PathBuf {
	let mut manifest_path = PathBuf::new();
	manifest_path.push(dir);
	manifest_path.push(filename);
	manifest_path
}
