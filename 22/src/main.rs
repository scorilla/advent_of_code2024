use std::fs::File;
use std::io::{self, BufReader, BufRead};

fn read_file_and_parse_i64(file_path: &str) -> io::Result<Vec<i64>> {
    // Open the file
    let file = File::open(file_path)?;
    let reader = BufReader::new(file);

    // Iterate over the lines and parse them as i64
    let mut numbers = Vec::new();
    for line in reader.lines() {
        let line = line?; // Handle any I/O errors
        match line.trim().parse::<i64>() {
            Ok(num) => numbers.push(num), // Successfully parsed an i64
            Err(_) => eprintln!("Skipping invalid line: {}", line), // Handle parsing errors
        }
    }

    Ok(numbers)
}


fn main() -> io::Result<()>{
    let file_path = "input_files/input.txt";
    let numbers = read_file_and_parse_i64(file_path)?;

    let mut sum: i64 = 0;

    
    for line in numbers {
        let mut x: i64 = line.clone();

        for _i in 1..=2000
        {
            x = evolve(x);
        }
        sum += x;
    }
    println!("Summe: {}", sum);
    Ok(())
}

fn evolve(mut secret: i64) -> i64 {
    secret = mix(secret << 6, secret);
    secret = prune(secret);

    secret = mix(secret >> 5, secret);
    secret = prune(secret);

    secret = mix(secret << 11, secret);
    secret = prune(secret);

    secret
}

fn mix(number: i64, secret: i64) -> i64{
    let mixed = number ^ secret;
    mixed
}
    

fn prune(number: i64) -> i64{
    let number = number % 16777216;
    number
}
