extern crate clap;

use clap::{App, Arg};

fn main() {
    let matches = App::new("Pack")
        .version("1.0")
        .author("Muthu Kumar")
        .about(" pack and move at a moment's notice")
        .arg(
            Arg::with_name("pack")
                .short("p")
                .long("pack")
                .help("Generate Pack manifest"),
        )
        .arg(
            Arg::with_name("add")
                .short("a")
                .long("add")
                .help("Add current path to Pack manifest"),
        )
        .arg(
            Arg::with_name("up")
                .short("u")
                .long("up")
                .help("packages all the chosen paths and creates an archive"),
        )
        .arg(
            Arg::with_name("push")
                .short("z")
                .long("push")
                .help("Push generated archive to location"),
        )
        .get_matches();

	println!("{:?}", matches.args);
}
