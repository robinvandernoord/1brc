const file = Bun.file('measurements.txt');

function process_line(line: string): [string, number] {
    let [location, value_as_str] = line.split(";")

    return [location, parseFloat(value_as_str)]
}

type Result = [number, number, number, number];

async function main() {
    const stream = file.stream();
    let newline = 10
    let semicolon = 59
    let period = 46
    let hyphen = 45

    let results: Map<string, Result> = {};

    let current_location = "";
    let current_number = 0.0;
    let negative = false;
    let found_semicolon = false;
    let row: Result;

    for await (const chunk of stream) {
        // parse raw bytes instead of per line

        let byte: number;
        for (byte of chunk) {
            if (byte == newline) {
                current_number = negative ? (current_number / -10) : current_number / 10

                row = results[current_location] || [0, 0, 0, 0]

                if (current_number < row[0]) {
                    row[0] = current_number
                } else if (current_number > row[1]) {
                    row[1] = current_number
                }

                row[2] += current_number
                row[3]++

                results[current_location] = row;

                negative = false;
                found_semicolon = false;
                current_location = ''
                current_number = 0.0
            } else if (byte == semicolon) {
                found_semicolon = true
            } else if (found_semicolon) {
                if (byte == hyphen) {
                    negative = true
                } else if (byte == period) {
                    // 
                } else {
                    //                                       ASCII 48 = 0
                    current_number = (current_number * 10) + (byte - 48)
                }
            } else {
                current_location += String.fromCharCode(byte);
            }
        }

        Bun.gc(true)
    }

    console.write("{")

    let key: string, value: Result;
    for (key of Object.keys(results).sort()) {
        value = results[key]
        console.write(`${key}=${value[0].toFixed(1)}/${(value[2] / value[3]).toFixed(1)}/${value[1].toFixed(1)}, `)
    }

    console.write("\b\b} \n")

}

main();
