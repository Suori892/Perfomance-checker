use std::thread;

fn factorial(n: u64) -> u64 {
    if n == 0 || n == 1 {
        return 1;
    }
    n * factorial(n - 1)
}

fn main() {
    let num_threads = 10;

    let handles: Vec<_> = (0..num_threads)
        .map(|_| {
            thread::spawn(|| {
                loop {
                    let num = rand::random::<u64>() % 20;
                    let result = factorial(num);
                    println!("Factorial of {}: {}", num, result);
                }
            })
        })
        .collect();

    for handle in handles {
        handle.join().unwrap();
    }
}
