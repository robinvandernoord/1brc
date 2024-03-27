# Tiny (10M)

| script              | runtime           | real      | user      | sys       | notes                              |
|---------------------|-------------------|-----------|-----------|-----------|------------------------------------|
| naive.rs            | rs -C opt-level=3 | 0m1,493s  | 0m1,433s  | 0m0,060s  |                                    |
| naive.v             | v -prod           | 0m1,701s  | 0m1,689s  | 0m0,012s  |                                    |
| naive.go            | go                | 0m1,714s  | 0m1,700s  | 0m0,040s  |                                    |
| naive.cpp           | g++ -O3           | 0m1,874s  | 0m1,842s  | 0m0,032s  |                                    |
| naive.v             | v -prod -autofree | 0m2,806s  | 0m2,453s  | 0m0,352s  |                                    |
| naive_ai.go         | go                | 0m2,238s  | 0m2,772s  | 0m0,259s  | loads the entire file into memory  |
| calculate_naive.py  | python3.11        | 0m3,644s  | 0m3,613s  | 0m0,029s  |                                    |
| calculate_naive.py  | mojo              | 0m3,861s  | 0m3,854s  | 0m0,008s  | ran fully via 'import_module'      |
| calculateAverage.py | python3.11        | 0m0,836s  | 0m5,544s  | 0m0,032s  |                                    |
| naive.cpp           | g++               | 0m7,167s  | 0m7,155s  | 0m0,012s  |                                    |
| calculate_naive.🔥  | mojo              | 0m7,526s  | 0m7,452s  | 0m0,076s  | incorrect float precision and sort |
| naive.rs            | rs                | 0m7,729s  | 0m7,713s  | 0m0,016s  |                                    |
| naive.v             | v                 | 0m7,759s  | 0m8,850s  | 0m0,626s  |                                    |
| threaded.v          | v -prod -autofree | 0m4,238s  | 0m16,074s | 0m4,311s  |                                    |
| threaded.v          | v -prod           | 0m9,621s  | 0m32,251s | 0m11,330s |                                    |
| naive.gleam         | gleam             | 1m11,860s | 1m11,731s | 0m0,977s  |                                    |

# Small (100M)

| script              | runtime           | real      | user      | sys       |
|---------------------|-------------------|-----------|-----------|-----------|
| naive.rs            | rs -C opt-level=3 | 0m13,991s | 0m13,819s | 0m0,172s  |
| naive.v             | v -prod           | 0m16,908s | 0m16,538s | 0m0,340s  |
| naive.go            | go                | 0m17,869s | 0m17,286s | 0m0,395s  |
| naive.cpp           | g++ -O3           | 0m18,661s | 0m18,468s | 0m0,184s  |
| calculate_naive.py  | python3.11        | 0m35,309s | 0m35,109s | 0m0,200s  |
| calculateAverage.py | python3.11        | 0m7,929s  | 0m51,864s | 0m0,242s  |
| calculateAverage.py | python3.12        | 0m8,264s  | 0m54,168s | 0m0,229s  |
| calculateAverage.py | python3.10        | 0m10,095s | 1m6,972s  | 0m0,295s  |
| threaded.v          | v -prod           | 1m25,566s | 4m43,189s | 1m59,115s |

# Big (1B)

| script              | runtime           | real      | user      | sys      |
|---------------------|-------------------|-----------|-----------|----------|
| naive.rs            | rs -C opt-level=3 | 2m21,365s | 2m17,903s | 0m3,340s |
| naive.v             | v -prod           | 2m44,253s | 2m40,981s | 0m3,260s |
| naive.go            | go                | 2m54,477s | 2m51,877s | 0m5,514s |
| naive.cpp           | g++ -O3           | 3m8,966s  | 3m4,816s  | 0m3,887s |
| calculate_naive.py  | python3.11        | 5m45,386s | 5m41,591s | 0m3,560s |
| calculateAverage.py | python3.11        | 1m18,557s | 8m42,056s | 0m5,032s |
