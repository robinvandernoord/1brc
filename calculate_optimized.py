import math
from collections import defaultdict
from typing import TextIO


def write_results(result: dict):
    print("{", end='')
    for name in sorted(result):
        row = result[name]
        print(f"{name}={row[0]}/{row[2] / row[3]:.1f}/{row[1]}", end=', ')

    print("\b\b} ")

import array
def process_file(f_in: TextIO):
    result = defaultdict(
        lambda: [math.inf, -math.inf, 0, 0]
    )  # place: min, max, total, sum

    for line in f_in:
        place, measurement = line.split(";")
        measurement = float(measurement)
        # speed up: int instead of float
        row = result[place]

        if measurement < row[0]:
            row[0] = measurement

        if measurement > row[1]:
            row[1] = measurement

        row[2] += measurement
        row[3] += 1

    write_results(result)


def main():
    with open('measurements.txt', 'r') as f:
        process_file(f)


if __name__ == '__main__':
    main()
