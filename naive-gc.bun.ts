const file = Bun.file('measurements.txt');

function process_line(line: string): [string, number] {
    let [location, value_as_str] = line.split(";")

    return [location, parseFloat(value_as_str)]
}

type Result = [number, number, number, number];

async function main() {
    const stream = file.stream();
    const dec = new TextDecoder();

    let line: string, text: string, parts: string[], idx: number, location: string, temp: number, row: Result;
    let trail = '';

    let results: Map<string, Result> = {};

    for await (const chunk of stream) {
        text = dec.decode(chunk, { "stream": true });
        parts = text.split("\n")

        for (idx = 0; idx < parts.length - 1; idx++) {
            line = trail + parts[idx];

            [location, temp] = process_line(line)

            row = results[location] || [Infinity, -Infinity, 0.0, 0.0]

            if (temp < row[0]) {
                row[0] = temp
            } else if (temp > row[1]) {
                row[1] = temp
            }
            row[2] += temp
            row[3]++

            results[location] = row;

            trail = '';

        }

        trail = parts[parts.length - 1];
        Bun.gc(true);
    }

    if (trail) {
        throw `Trailing data: ${trail}`
    }

    console.write("{")

    let key: string, value: Result;
    for(key of Object.keys(results).sort()) {
        value = results[key]
        console.write(`${key}=${value[0].toFixed(1)}/${(value[2] / value[3]).toFixed(1)}/${value[1].toFixed(1)}, `)
    }

    console.write("\b\b} \n")

}

main();
