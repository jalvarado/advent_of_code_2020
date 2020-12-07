use std::fs::File;
use std::io::{BufRead, BufReader};
use regex::Regex;

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

fn validate_byr(year: i32) -> bool {
  year >= 1920 && year <= 2002
}

fn validate_iyr(year: i32) -> bool {
  year >= 2010 && year <= 2020
}

fn validate_eyr(year: i32) -> bool {
  year >= 2020 && year <= 2030
}

fn validate_hgt(height: &String) -> bool {
  if height.ends_with("in") {
    let h = height.strip_suffix("in")
      .unwrap_or("Inalid height")
      .parse::<i32>();
    match h {
      Ok(v) => v >= 59 && v <= 76,
      Err(_) => false,
    }
  } else {
    let h = height.strip_suffix("cm")
      .unwrap_or("Invalid height")
      .parse::<i32>();
    match h {
      Ok(v) => v >= 150 && v <= 193,
      Err(_) => false,
    }
  }
}

fn validate_hcl(color: &String) -> bool {
  let re = Regex::new(r"#([0-9a-f]{6}\z)").unwrap();
  re.is_match(&color)
}

fn validate_ecl(color: &String) -> bool {
  let allowed_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];
  allowed_colors.iter().any(|c| *c == color)
}

fn validate_pid(pid: &String) -> bool {
  let re = Regex::new(r"\A\d{9}\z").unwrap();
  re.is_match(&pid)
}

fn validate_passport_data(passport: &Passport) -> bool {
  validate_byr(passport.byr) &&
  validate_iyr(passport.iyr) &&
  validate_eyr(passport.eyr) &&
  validate_hgt(&passport.hgt) &&
  validate_hcl(&passport.hcl) &&
  validate_ecl(&passport.ecl) &&
  validate_pid(&passport.pid)
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

    println!("Part One: {}", valid_count);

    let part2_count = passports.iter().fold(0, |acc, passport| {
      if validate_passport(passport) && validate_passport_data(passport) {
        return acc + 1;
      } else {
        return acc;
      }
    });

    println!("Part Two: {}", part2_count);
}