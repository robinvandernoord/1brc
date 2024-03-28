# Tiny (10M)

| script              | runtime           | wall    | user  | sys  | cpu  | mem (kb) | notes                              | 
|---------------------|-------------------|---------|-------|------|------|----------|------------------------------------|
| naive.rs            | rs -C opt-level=3 | 0:01.44 | 1.43  | 0.01 | 99%  | 2048     |                                    |
| naive.v             | v -prealloc -prod | 0:01.75 | 1.53  | 0.22 | 100% | 905088   | crashes on larger datasets         |
| naive.v             | v -prod           | 0:01.67 | 1.64  | 0.02 | 100% | 2560     |                                    |
| naive.go            | go                | 0:01.72 | 1.69  | 0.05 | 101% | 7228     |                                    |
| naive.cpp           | g++ -O3           | 0:01.90 | 1.90  | 0.00 | 99%  | 3712     |                                    |
| naive.v             | v -gc none -prod  | 0:02.47 | 2.06  | 0.40 | 99%  | 2049536  |                                    |
| naive.v             | v -autofree -prod | 0:02.94 | 2.66  | 0.27 | 99%  | 1253760  |                                    |
| naive_ai.go         | go                | 0:02.25 | 2.78  | 0.24 | 134% | 689324   | loads the entire file into memory  |
| naive.bun.ts        | bun               | 0:02.89 | 2.93  | 0.13 | 106% | 145704   |                                    |
| calculate_naive.py  | python3.11        | 0:03.43 | 3.38  | 0.03 | 99%  | 10616    |                                    |
| calculate_naive.py  | python3.12        | 0:03.66 | 3.64  | 0.02 | 100% | 11648    |                                    |
| calculate_naive.py  | mojo              | 0:03.75 | 3.66  | 0.05 | 99%  | 18816    | ran fully via 'import_module'      |
| calculate_naive.py  | python3.10        | 0:04.25 | 4.22  | 0.03 | 100% | 10624    |                                    |
| naive-gc.bun.ts     | bun               | 0:04.35 | 4.27  | 1.25 | 127% | 74840    | `Bun.gc(true)` after each chunk    |
| naive-char.bun.ts   | bun               | 0:05.64 | 5.60  | 0.17 | 102% | 111824   | Invalid character encoding         |
| calculateAverage.py | python3.11        | 0:00.81 | 5.16  | 0.07 | 639% | 14592    |                                    |
| naive.node.js       | node              | 0:05.29 | 5.31  | 5.30 | 200% | 81028    |                                    |
| calculateAverage.py | python3.12        | 0:00.86 | 5.48  | 0.04 | 636% | 15616    |                                    |
| naive.cpp           | g++               | 0:06.88 | 6.87  | 0.01 | 100% | 3712     |                                    |
| calculateAverage.py | python3.10        | 0:01.12 | 6.94  | 0.04 | 621% | 14208    |                                    |
| naive.v             | v -gc none        | 0:07.48 | 6.96  | 0.52 | 100% | 2050432  |                                    |
| naive.v             | v -prealloc       | 0:07.20 | 6.97  | 0.23 | 100% | 907008   |                                    |
| naive.rs            | rs                | 0:07.54 | 7.52  | 0.01 | 100% | 2048     |                                    |
| calculate_naive.🔥  | mojo              | 0:07.67 | 7.59  | 0.08 | 100% | 12908    | incorrect float precision and sort |
| naive.v             | v -autofree       | 0:08.43 | 8.14  | 0.29 | 100% | 1254656  |                                    |
| naive.v             | v                 | 0:07.79 | 8.57  | 0.86 | 121% | 4480     |                                    |
| threaded.v          | v -gc none -prod  | 0:04.72 | 15.98 | 5.39 | 452% | 2363648  |                                    |
| threaded.v          | v -autofree -prod | 0:04.61 | 16.99 | 4.47 | 465% | 1254784  |                                    |
| threaded.v          | v -prod           | 0:07.56 | 23.91 | 6.67 | 404% | 7424     |                                    |
| threaded.v          | v -gc none        | 0:07.70 | 35.94 | 4.42 | 523% | 2364544  |                                    |
| threaded.v          | v -autofree       | 0:07.72 | 36.37 | 3.85 | 520% | 1255936  |                                    |
| threaded.v          | v                 | 0:12.96 | 51.01 | 5.99 | 439% | 9472     |                                    |
| naive.gleam         | gleam             | 1:10.46 | 70.61 | 0.72 | 101% | 63252    |                                    |
| threaded.v          | v -prealloc       | 0:00.00 | 0.00  | 0.00 | 557% | 4736     | Crash                              |
| threaded.v          | v -prealloc -prod | 0:00.00 | 0.00  | 0.00 | 24%  | 3456     | segmentation fault                 |

# Small (100M)

| script              | runtime           | wall    | user   | sys   | cpu  | mem (kb) | notes | 
|---------------------|-------------------|---------|--------|-------|------|----------|-------|
| naive.rs            | rs -C opt-level=3 | 0:14.69 | 14.36  | 0.31  | 99%  | 2048     |       |
| naive.v             | v -prod           | 0:16.80 | 16.66  | 0.13  | 99%  | 2688     |       |
| naive.go            | go                | 0:17.37 | 17.31  | 0.32  | 101% | 7096     |       |
| naive.cpp           | g++               | 0:19.21 | 19.07  | 0.13  | 99%  | 3584     |       |
| naive.bun.ts        | bun               | 0:27.54 | 27.90  | 0.71  | 103% | 200964   |       |
| calculate_naive.py  | python3.11        | 0:34.66 | 34.43  | 0.22  | 99%  | 10752    |       |
| naive-gc.bun.ts     | bun               | 0:43.42 | 43.28  | 12.95 | 129% | 75220    |       |
| calculateAverage.py | python3.11        | 0:07.81 | 51.74  | 0.28  | 665% | 14848    |       |
| calculate_naive.🔥  | mojo              | 1:17.72 | 74.31  | 0.91  | 96%  | 12932    |       |
| threaded.v          | v -prod           | 1:13.03 | 234.20 | 65.08 | 409% | 7552     |       |
| naive.node.js       | node              | 0:53.00 | 53.04  | 53.12 | 200% | 81340    |       |

# Big (1B)

| script              | runtime           | wall    | user   | sys    | cpu  | mem (kb) | notes | 
|---------------------|-------------------|---------|--------|--------|------|----------|-------|
| naive.rs            | rs -C opt-level=3 | 2:25.29 | 141.36 | 3.89   | 99%  | 2048     |       |
| naive.v             | v -prod           | 2:53.99 | 166.60 | 3.87   | 97%  | 2688     |       |
| naive.go            | go                | 2:56.10 | 172.74 | 6.25   | 101% | 7656     |       |
| naive.cpp           | g++ -O3           | 3:14.07 | 190.00 | 4.04   | 99%  | 3584     |       |
| naive.bun.ts        | bun               | 4:53.66 | 264.10 | 10.42  | 93%  | 1119156  |       |
| calculate_naive.py  | python3.11        | 5:48.76 | 342.85 | 4.25   | 99%  | 10872    |       |
| calculateAverage.py | python3.11        | 1:19.32 | 521.87 | 5.65   | 665% | 14592    |       |
| naive.node.js       | node              | 8:54.49 | 531.29 | 536.28 | 199% | 81676    |       |
| naive-gc.bun.ts     | bun               | 8:23.80 | 584.25 | 138.05 | 143% | 90356    |       |
