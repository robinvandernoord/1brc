use std::collections::HashMap;
use std::f64::INFINITY;
use std::fs::File;
use std::io::{self, BufRead};

fn read_file(filename: &str) -> io::Result<io::Lines<io::BufReader<File>>> {
    let file = File::open(filename)?;
    return Ok(io::BufReader::new(file).lines())
}

fn split<'a, 'b>(value: &'a str, sep: &'b str) -> (&'a str, &'a str) {
    let values: Vec<&str> = value.split(sep).collect();
    return (values[0], values[1])
}

#[derive(Debug)]
struct Measurement {
    min: f64,
    max: f64,
    sum: f64,
    cnt: f64,
}

impl Measurement {
    fn new() -> Measurement {
        Measurement {
            min: INFINITY,
            max: -INFINITY,
            sum: 0.0,
            cnt: 0.0,
        }
    }

    fn avg(&self) -> f64 {
        self.sum / self.cnt
    }

    fn format(&self) -> String {
        return format!("{:.1}/{:.1}/{:.1}", self.min, self.avg(), self.max);
    }
}

fn as_float(value_as_str: &str) -> f64 {
    return value_as_str.parse::<f64>().unwrap_or(0.0)
}

fn print_results(readings: HashMap<String, Measurement>) {
    let mut cities: Vec<_> = readings.iter().collect();

    cities.sort_by_key(|k| k.0);

    print!("{{");
    for (city, measurement) in cities.iter() {
        print!("{}={}, ", city, measurement.format());
    }

    print!("\x08\x08}} \n")

}

fn main () {
    let reader = read_file("measurements.txt");
    if !reader.is_ok() {
        panic!("Unknown file.")
    }

    let mut readings: HashMap<String, Measurement> = HashMap::new();

    for line in reader.unwrap().flatten() {
        let (location, value_as_str) = split(&line, ";");
        let value_as_float = as_float(value_as_str);

        // let reading: &&Measurement = readings.get(location).unwrap_or_else(|| &new_measurement());
        let reading = readings.entry(location.to_string()).or_insert_with(&Measurement::new);

        if value_as_float > reading.max {
            // reading.max.max(other)
            reading.max = value_as_float
        }

        if value_as_float < reading.min {
            reading.min = value_as_float
        }

        reading.sum += value_as_float;
        reading.cnt += 1.0;
    }

    print_results(readings);

}
