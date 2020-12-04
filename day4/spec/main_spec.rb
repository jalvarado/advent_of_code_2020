require_relative "../main"

RSpec.describe "Day4" do
  describe "valid_data?" do
    let(:passport) do
      {
        "ecl" => "gry",
        "pid" => "860033327",
        "eyr" => "2020",
        "hcl" => "#fffffd",
        "byr" => "1937",
        "iyr" => "2017",
        "hgt" => "183cm"
      }
    end

    it "validates the passport data" do
      expect(has_valid_data?(passport)).to be true
    end

    it "does not validate an invalid passport" do
      passports = parse_passport_batch("spec/fixtures/invalid_passports.txt")
      expect(passports.all? { |passport| !has_valid_data?(passport) }).to be true
    end
  end

  describe "validate_hcl" do
    it "must include a #" do
      expect(validate_hcl("000000")).to be false
    end
  end

  describe "validate_hgt" do
    it "validates inches" do
      expect(validate_hgt("50in")).to be false
      expect(validate_hgt("59in")).to be true
      expect(validate_hgt("76in")).to be true
      expect(validate_hgt("100in")).to be false
    end

    it "validates cm" do
      expect(validate_hgt("50cm")).to be false
      expect(validate_hgt("150cm")).to be true
      expect(validate_hgt("193cm")).to be true
      expect(validate_hgt("200cm")).to be false
    end

    it "handles bad input" do
      expect(validate_hgt("150")).to be false
    end
  end

  describe "validate_byr" do
    it "must be 4 digits" do
      expect(validate_byr("132")).to be false
      expect(validate_byr("2000")).to be true
    end

    it "must be between 1920 and 2002" do
      expect(validate_byr("1900")).to be false
      expect(validate_byr("1920")).to be true
      expect(validate_byr("2000")).to be true
      expect(validate_byr("2002")).to be true
      expect(validate_byr("2020")).to be false
    end
  end

  describe "validate_iyr" do
    it "must be 4 digits" do
      expect(validate_iyr("132")).to be false
      expect(validate_iyr("2010")).to be true
    end

    it "must be between 2010 and 2020" do
      expect(validate_iyr("1900")).to be false
      expect(validate_iyr("2010")).to be true
      expect(validate_iyr("2011")).to be true
      expect(validate_iyr("2020")).to be true
      expect(validate_iyr("2021")).to be false
    end
  end

  describe "validate_eyr" do
    it "must be 4 digits" do
      expect(validate_eyr("132")).to be false
      expect(validate_eyr("2020")).to be true
    end

    it "must be between 2020 and 2030" do
      expect(validate_eyr("1900")).to be false
      expect(validate_eyr("2020")).to be true
      expect(validate_eyr("2030")).to be true
      expect(validate_eyr("2051")).to be false
    end
  end

  describe "valid_passport?" do
    it "ignores missing cid key" do
      valid_passport = {
        "ecl" => "gry",
        "pid" => "860033327",
        "eyr" => "2020",
        "hcl" => "#fffffd",
        "byr" => "1937",
        "iyr" => "2017",
        "hgt" => "183cm"
      }
      expect(valid_passport?(valid_passport)).to be true
    end

    it "returns true for a valid passport" do
      valid_passport = {
        "ecl" => "gry",
        "pid" => "860033327",
        "eyr" => "2020",
        "hcl" => "#fffffd",
        "byr" => "1937",
        "iyr" => "2017",
        "cid" => "147",
        "hgt" => "183cm"
      }
      expect(valid_passport?(valid_passport)).to be true
    end

    it "returns false for an invalid passport" do
      invalid_passport = {
        "pid" => "860033327",
        "eyr" => "2020",
        "hcl" => "#fffffd",
        "byr" => "1937",
        "iyr" => "2017",
        "cid" => "147",
        "hgt" => "183cm"
      }
      expect(valid_passport?(invalid_passport)).to be false
    end
  end
  describe "parse_passport_batch" do
    it "should return an array of hashes" do
      passports = parse_passport_batch("spec/fixtures/input.txt")
      expect(passports.count).to eq 4
      expect(passports.all? { |h| h.is_a?(Hash) }).to be true
    end

    it "parses the passport correctly" do
      expected_passport = {
        "ecl" => "gry",
        "pid" => "860033327",
        "eyr" => "2020",
        "hcl" => "#fffffd",
        "byr" => "1937",
        "iyr" => "2017",
        "cid" => "147",
        "hgt" => "183cm"
      }
      passports = parse_passport_batch("spec/fixtures/input.txt")
      expect(passports.first).to eq expected_passport
    end
  end
end
