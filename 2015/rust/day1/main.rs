use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
  part2()
}

fn part1() {
  // Create a path to the desired file
  let path = Path::new("input.txt");

  // Open the path in read-only mode, returns `io::Result<File>`
  let mut file = match File::open(&path) {
    // The `description` method of `io::Error` returns a string that
    // describes the error
    Err(why) => panic!("ERROR: {}", why),
    Ok(file) => file,
  };

  // Read the file contents into a string, returns `io::Result<usize>`
  let mut s = String::new();
  file.read_to_string(&mut s);

  let chars = s.chars();

  let mut left = 0;
  let mut right = 0;
  for c in chars {
    if c == '(' {
      left = left + 1;
    }
    if c == ')' {
      right = right + 1;
    }
  }
  println!("{}", left - right);
}

fn part2() {
  // Create a path to the desired file
  let path = Path::new("input.txt");

  // Open the path in read-only mode, returns `io::Result<File>`
  let mut file = match File::open(&path) {
    // The `description` method of `io::Error` returns a string that
    // describes the error
    Err(why) => panic!("ERROR: {}", why),
    Ok(file) => file,
  };

  // Read the file contents into a string, returns `io::Result<usize>`
  let mut s = String::new();
  file.read_to_string(&mut s);

  let chars = s.chars();

  let mut where_is_santa = 0;
  for (i, c) in chars.enumerate() {
    if c == '(' {
      where_is_santa = where_is_santa + 1
    }
    if c == ')' {
      where_is_santa = where_is_santa - 1
    }
    if where_is_santa == -1 {
      println!("{}", i + 1);
      return
    }
  }
}
