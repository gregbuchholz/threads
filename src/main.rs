use std::thread;

fn xs() {

    for _ in 0 .. 10 {
        println!("X");
    }
}

fn main() {

    let t1 = thread::spawn(xs);

    t1.join().unwrap();
}
