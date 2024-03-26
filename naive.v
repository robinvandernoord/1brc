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
	min f64 = math.inf(1)
	max f64 = math.inf(-1)
	sum f64
	cnt u64
}

fn (self &Row) avg() f64 {
	return self.sum / self.cnt
}

fn (self &Row) report() string {
	return '${self.min}/${self.avg():.1f}/${self.max}'
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

fn new_row() &Row {
	return &Row{}
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

fn write_results(readings map[string]&Row) {
	print('{')

	mut names := readings.keys()
	names.sort()

	for name in names {
		row := readings[name] or { continue }

		print('${name}=')
		print(row.report())
		print(', ')
	}

	println('\b\b} ')
}

fn main() {
	mut reader := stream_file('measurements.txt')

	mut readings := map[string]&Row{}

	for {
		line := reader.read_line() or { break }

		// location, value_as_str := split(line, ';') or { continue }
		parts := line.split(';')

		// value_as_f := strconv.atof64(value_as_str)!
		value_as_f := parse_float_faster(parts[1])

		mut entry := readings[parts[0]] or { new_row() }

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

	write_results(readings)
}
