import io
import os
import math
// import strconv

fn stream_file(filename string) &io.BufferedReader {
	fd := os.open_file(filename, 'r') or { panic('failed to open file ${filename}!') }
	return io.new_buffered_reader(reader: fd) // 128 * 1024
}

fn split(txt string, sep string) !(string, string) {
	parts := txt.split(sep)

	if parts.len != 2 {
		return error('Invalid length')
	}

	return parts[0], parts[1]
}

struct Row {
pub mut:
	loc string
	min f64 = math.inf(1)
	max f64 = math.inf(-1)
	sum f64
	cnt u64
}

fn (self &Row) avg() f64 {
	return self.sum / self.cnt
}

fn (self &Row) report() string {
	return '${self.loc}=${self.min}/${self.avg():.1f}/${self.max}'
}

fn Row.sort(a &Row, b &Row) int {
	if a.loc < b.loc {
		return -1
	} else {
		return 1
	}
}

fn lowest[T](val1 T, val2 T) T {
	if val1 < val2 {
		return val1
	} else {
		return val2
	}
}

fn highest[T](val1 T, val2 T) T {
	if val1 > val2 {
		return val1
	} else {
		return val2
	}
}

fn new_row(loc string) &Row {
	return &Row{
		loc: loc
	}
}

// fn (mut self Row) update(value f64) Row {
// 	return Row {
// 		min: lowest(self.min, value),
// 		max: highest(self.max, value),
// 		sum: self.sum + value,
// 		cnt: self.cnt + 1
// 	}
// }

fn parse_float_faster(value_as_str string) f64 {
	mut result := 0.0
	mut positive := true
	for letter in value_as_str.runes() {
		match letter {
			`-` { positive = false }
			`0` { result = result * 10 + 0 }
			`1` { result = result * 10 + 1 }
			`2` { result = result * 10 + 2 }
			`3` { result = result * 10 + 3 }
			`4` { result = result * 10 + 4 }
			`5` { result = result * 10 + 5 }
			`6` { result = result * 10 + 6 }
			`7` { result = result * 10 + 7 }
			`8` { result = result * 10 + 8 }
			`9` { result = result * 10 + 9 }
			else {}
		}
	}

	if !positive {
		result = -result
	}

	return result / 10
}

/*
def write_results(result: dict):
    print("{", end='')
    for name in sorted(result):
        row = result[name]
        print(f"{name}={row[0]}/{row[2] / row[3]:.1f}/{row[1]}", end=', ')

    print("\b\b} ")
*/

type RowMap = map[string]&Row

fn write_results(readings [][]&Row) {
	print('{')

	for rows in readings {
		for row in rows {
			print(row.report())
			print(', ')
		}
	}

	println('\b\b} ')
}

fn new_rowmap() RowMap {
	return map[string]&Row{}
}

fn threaded(c chan string) []&Row {
	mut readings := new_rowmap()

	for {
		line := <-c or { break }

		// location, value_as_str := split(line, ';') or { continue }
		parts := line.split(';')

		// value_as_f := strconv.atof64(value_as_str)!
		value_as_f := parse_float_faster(parts[1])

		mut entry := readings[parts[0]] or { new_row(parts[0]) }

		if entry.min > value_as_f {
			entry.min = value_as_f
		}
		if entry.max < value_as_f {
			entry.max = value_as_f
		}

		entry.sum += value_as_f
		entry.cnt += 1

		readings[parts[0]] = entry
	}

	eprintln("post break, sorting values")

	mut values := readings.values()
	values.sort(a.loc < b.loc)
	return values
}

fn first_key[K, V](m map[K]V) ?K {
	if m.len == 0 {
		return none
	}

	return m.keys()[0]
}

fn first_value[K, V](m map[K]V) ?V {
	k := first_key(m) or { return none }
	return m[k]
}

const max_threads := 7 // one thread per 4 chars + 1 extra (26 / 4 + 1) - 27 is too much
const max_threads_minus_one := max_threads - 1

fn main() {
	mut reader := stream_file('measurements.txt')

	// mut chans := []chan string {len: 27, init: chan string {cap: 1000}}
	// mut threads := []thread RowMap {len: 27, init: spawn threaded(chans[index], index)} // 26 normal letters + one 'others'


	mut chans := []chan string{cap: max_threads}
	mut threads := []thread []&Row{cap: max_threads}

	for index in 0 .. max_threads {
		chans << chan string{cap: 10_000}
		threads << spawn threaded(chans[index])
	}

	for {
		line := reader.read_line() or { break }
		// first := line.str[0].ascii_str().to_lower()
		unsafe {
			mut first_char := (line.to_lower().str[0] - 97) / 4 // divide to limit amount of threads

			if first_char > max_threads_minus_one {
				first_char = max_threads_minus_one
			}

			chans[first_char] <- line
		}
	}

	eprintln("sync done, waiting for threads")

	chans.map(fn (a chan string) bool {
		a.close()
		return true
	})

	results := threads.wait()

	eprintln("threads done, printing result")

	write_results(results)
}
