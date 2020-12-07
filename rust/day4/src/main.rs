use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Debug, Default)]
struct Passport {
  byr: i32,
  iyr: i32,
  eyr: i32,
  hgt: String,
  hcl: String,
  ecl: String,
  pid: String,
  cid: String,
}

fn validate_passport(passport: &Passport) -> bool {
  passport.byr != 0 &&
    passport.iyr != 0 &&
    passport.eyr != 0 &&
    !passport.hgt.is_empty() &&
    !passport.hcl.is_empty() &&
    !passport.ecl.is_empty() &&
    !passport.pid.is_empty()
}

fn main() {
  let file = File::open("input/input.txt").expect("No such file.");
  let buf = BufReader::new(file);

  let lines: Vec<String> = buf
    .lines()
    .map(|line| line.expect("Could not parse line."))
    .collect();

  println!("Read {} lines from file.", lines.len());

  let mut passport_data: Vec<String> = vec![];
  let mut parts: Vec<&str> = vec![];
  for i in 0..lines.len() {
    let line = &lines[i].trim();

    if !line.is_empty() {
      parts.push(&line);

      if i == lines.len() - 1 {
        passport_data.push(parts.join(" "));
      }
    } else {
      passport_data.push(parts.join(" "));
      parts = vec![];
    }
  }

  let passports: Vec<Passport> = passport_data.iter()
    .map(|passport_str| {
      let mut passport: Passport = Passport::default();

      /* Split the data string into parts of "key:value" */
      let parts: Vec<&str> = passport_str.split(" ").collect();
      let attrs = parts.into_iter()
        .map(|part| {
          let pair: Vec<&str> = part.split(":").collect();
          let attrib_tuple = match &pair[..] {
            &[key, value, ..] => (key, value),
            _ => unreachable!(),
          };
          return attrib_tuple;
        })
        .collect::<Vec<(&str,&str)>>();

        for (key, value) in attrs {
          match key {
            "byr" => passport.byr = value.to_string().parse::<i32>().unwrap(),
            "iyr" => passport.iyr = value.to_string().parse::<i32>().unwrap(),
            "eyr" => passport.eyr = value.to_string().parse::<i32>().unwrap(),
            "hgt" => passport.hgt = value.to_string(),
            "hcl" => passport.hcl = value.to_string(),
            "ecl" => passport.ecl = value.to_string(),
            "pid" => passport.pid = value.to_string(),
            "cid" => passport.cid = value.to_string(),
            _ => panic!("Invalid key"),
          }
        }

      return passport;
    })
    .collect();

    println!("Passport count: {}", passports.len());

    let valid_count = passports.iter().fold(0, |acc, passport| {
      if validate_passport(passport) { return acc + 1;} else { return acc; }
    });

    println!("Part One: {}", valid_count)

}