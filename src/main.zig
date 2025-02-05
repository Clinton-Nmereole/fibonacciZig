const std = @import("std");
const Int = std.math.big.int.Managed;
const math = std.math;
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const gpa_allocator = gpa.allocator();

fn fibonacci(n: u64) u64 {
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fn linearFibonacci(n: u64, allocator: std.mem.Allocator) !Int {
    var a = try Int.initSet(allocator, 0);
    var b = try Int.initSet(allocator, 1);
    //defer a.deinit();
    //defer b.deinit();
    var loop = n;

    while (loop > 0) : (loop -= 1) {
        var c = try Int.init(allocator);
        //defer c.deinit();
        try c.add(&a, &b);
        a.swap(&b);
        b.swap(&c);
    }

    //The below line causes the function to return the actual string of the number instead of "BigInt{}"
    //const result = try a.toString(allocator, 10, std.fmt.Case.lower);
    return a;
}

fn fibonacciExponent(n: u64, allocator: std.mem.Allocator) !Int {
    var a = try Int.initSet(allocator, 0);
    var b = try Int.initSet(allocator, 1);
    var loop = n;
    while (loop > 0) : (loop -= 1) {
        var ab2 = try Int.init(allocator);
        var a2 = try a.clone();
        try a2.pow(&a2, 2);

        var b2 = try b.clone();
        try b2.pow(&b2, 2);

        try ab2.add(&a, &b);

        try ab2.pow(&ab2, 2);

        try a.add(&a2, &b2);

        try b.sub(&ab2, &a2);
    }
    return b;
}

pub fn main() !void {
    //const fib50000 = try linearFibonacci(50000, gpa_allocator);

    //const linearfib = linearFibonacci(50000, gpa_allocator);
    const exponentfib = fibonacciExponent(21, gpa_allocator);
    //std.debug.print("The 3500th Fibonacci number is {any}\n", .{fib50000});
    //std.debug.print("The 40th Fibonacci number is {d}\n", .{fib40_2});
    //std.debug.print("The 50,000th Fibonacci number using linear is {any}\n", .{linearfib});
    std.debug.print("The 50,000th Fibonacci number using exponent is {any}\n", .{exponentfib});
    //const a = try Int.initSet(gpa_allocator, 5);
    //const a2 = try a.clone();
    //try a2.pow(&a, 2);
    //std.debug.print("What is the value of a  {any}\n", .{a});
    //std.debug.print("What is the value of a2 {any}\n", .{@TypeOf(a2)});
}
