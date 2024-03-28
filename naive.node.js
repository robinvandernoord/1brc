const { open } = require('node:fs/promises');

async function main() {
    const file = await open('measurements.txt');

    const results = {};

    let row, name, value_as_str, value_as_float, line;
    for await (line of file.readLines()) {
        [name, value_as_str] = line.split(";")

        value_as_float = parseFloat(value_as_str)

        //                     min, max, sum, cnt
        row = results[name] || [Infinity, -Infinity, 0.0, 0]
        if (value_as_float < row[0]) {
            row[0] = value_as_float
        } else if (value_as_float > row[1]) {
            row[1] = value_as_float
        }

        row[2] += value_as_float
        row[3]++

        results[name] = row;
    }

    process.stdout.write("{")

    let key, value;
    for(key of Object.keys(results).sort()) {
        value = results[key];
        process.stdout.write(`${key}=${value[0].toFixed(1)}/${(value[2] / value[3]).toFixed(1)}/${value[1].toFixed(1)}, `)
    }

    process.stdout.write("\b\b} \n")
}

main();
