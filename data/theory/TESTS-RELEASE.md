# Release tests and benchmarks

Дата отчета (локальное время): `2026-04-22T14:54:11+03:00`  
Дата отчета (UTC): `2026-04-22T11:54:11+00:00`

Репозиторий: `/Users/mrk-3/Проекты/if97_calculator`

Цель:
- зафиксировать финальную release-валидацию проекта;
- повторить структуру `TESTS.md`, но для release-сборок и release-бенчмарков;
- отдельно включить нагрузочные тесты, которые были пропущены в прошлом прогоне.

## Release build

### Workspace

Команда:
```bash
cargo build --workspace --release --frozen --color never
```

Результат:
- `OK`
- Время: `2m 58s`
- В workspace собрался весь release-путь проекта: `if97_core`, `if97_app_api`, `if97_calculator_service`, `if97_calculator_native`, `if97_calculator_fltk`, `if97_calculator_web`.

### WASM target

Команда:
```bash
cargo build -p if97_calculator_web --target wasm32-unknown-unknown --release --frozen --color never
```

Результат:
- `OK`
- Время: `9.48s`

### Web packaging

Команда:
```bash
cd wasm && NO_COLOR=true trunk build --release
```

Результат:
- `OK`
- Артефакты успешно собраны в `wasm/dist/`.

## Release tests

### if97_app_api

Команда:
```bash
cargo test -p if97_app_api --release --frozen --color never -- --nocapture
```

Результат:
- `OK`
- Время: `9.61s`
- `2` integration tests passed.

### if97_core

Команда:
```bash
cargo test -p if97_core --release --frozen --color never -- --nocapture
```

Результат:
- `OK`
- Время: `10.00s`
- `18` unit tests passed.
- `1` integration CSV test passed.
- `1` ignored load test остался ignored в обычном `cargo test` и запускался отдельно как benchmark.
- `1` doctest passed.

### if97_calculator_service

Команда:
```bash
cargo test -p if97_calculator_service --release --frozen --color never -- --nocapture
```

Результат:
- `OK`
- Время: `24.22s`
- `5` unit/integration tests passed.
- `grpc_healthcheck` и `grpc_loadtest` были собраны как отдельные release binaries.

### if97_calculator_fltk

Команда:
```bash
cargo test -p if97_calculator_fltk --release --frozen --color never -- --nocapture
```

Результат:
- `OK`
- Время: `5.72s`
- Тестов нет, пакет успешно собрался и прошел doc-tests.

### if97_calculator_native

Команда:
```bash
cargo test -p if97_calculator_native --release --frozen --color never -- --nocapture
```

Результат:
- `OK`
- Время: `1m 31s`
- `3` smoke tests passed.
- `1` ignored perf-test не запускался в этом прогоне.

## Release benchmarks

### Bench 1: CPU нагрузка ядра из `if97_core`

Команда:
```bash
IF97_LOAD_ITERS=200 cargo test -p if97_core --test load_stress_test --release --frozen --color never -- --ignored --nocapture
```

Результат:
- `OK`

Вывод:
```text
load_stress_core_csv: rows=242 iters=200 total_rows=48400 elapsed=0.817s rows/s=59265 calls/s=237058 ok=190800 err=2800 checksum=1526026781224467136
```

### Bench 2: `if97_loadtest`

Release build:
```bash
cargo build -p if97_calculator_service --bin if97_loadtest --features loadtest --release --frozen --color never
```

Результат:
- `OK`
- Время: `19.47s`

Серия замеров:
```bash
for i in $(seq 1 10); do ./target/release/if97_loadtest --iters 200 --threads 8; done
```

Вывод:
```text
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.245s rows/s=197672 calls/s=790690 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.229s rows/s=210964 calls/s=843854 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.225s rows/s=215256 calls/s=861026 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.217s rows/s=222852 calls/s=891409 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.217s rows/s=223301 calls/s=893202 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.219s rows/s=221065 calls/s=884262 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.220s rows/s=220014 calls/s=880055 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.218s rows/s=221585 calls/s=886342 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.227s rows/s=213062 calls/s=852246 ok=190800 err=2800 checksum=1526026781224467136
if97_loadtest: profile=release rows=242 iters=200 threads=8 total_rows=48400 elapsed=0.217s rows/s=222585 calls/s=890338 ok=190800 err=2800 checksum=1526026781224467136
```

### Bench 3: генерация купола насыщения

Команда:
```bash
cargo test -p if97_calculator_native --release --frozen --color never -- --ignored --nocapture
```

Результат:
- `OK`

Вывод:
```text
dome_perf: x=T y=P points=717 elapsed=0.002s
dome_perf: x=V y=P points=4249 elapsed=0.005s
dome_perf: x=S y=P points=1586 elapsed=0.003s
dome_perf: x=H y=P points=1739 elapsed=0.003s
dome_perf: x=V y=T points=2396 elapsed=0.002s
dome_perf: x=S y=T points=825 elapsed=0.001s
dome_perf: x=H y=T points=861 elapsed=0.001s
dome_perf: x=S y=H points=1148 elapsed=0.001s
```

### Bench 4: gRPC transport

Release build:
```bash
cargo build -p if97_calculator_service --bin if97_calculator_service --bin grpc_loadtest --bin grpc_healthcheck --release --frozen --color never
```

Результат:
- `OK`
- Время: `15.30s`

Запуск сервиса:
```bash
IF97_GRPC_ADDR=127.0.0.1:50051 IF97_KERNEL=core IF97_IO_THREADS=2 IF97_CPU_THREADS=8 IF97_MAX_IN_FLIGHT_PER_CONN=8 IF97_MAX_IN_FLIGHT_GLOBAL=8 IF97_DRAIN_SECS=2 RUST_LOG=info ./target/release/if97_calculator_service
```

Health-check:
```bash
./target/release/grpc_healthcheck --addr 127.0.0.1:50051
```

Вывод:
```text
grpc_healthcheck: addr=127.0.0.1:50051 service="if97.v1.If97Service" status=Serving
grpc_healthcheck: addr=127.0.0.1:50051 service="" status=Serving
```

Серия замеров:
```bash
for i in $(seq 1 6); do ./target/release/grpc_loadtest --addr 127.0.0.1:50051 --streams 1 --batches 500 --batch-size 2048 --in-flight 8; done
```

Вывод:
```text
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.538s batches/s=929 points/s=1902617
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.528s batches/s=947 points/s=1939888
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.527s batches/s=948 points/s=1942150
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.523s batches/s=956 points/s=1957870
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.523s batches/s=955 points/s=1956092
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=500 batch_size=2048 total_batches=500 elapsed=0.525s batches/s=952 points/s=1950242
```

Длинный прогон:
```bash
./target/release/grpc_loadtest --addr 127.0.0.1:50051 --streams 1 --batches 2000 --batch-size 2048 --in-flight 8
```

Вывод:
```text
grpc_loadtest: profile=release addr=127.0.0.1:50051 streams=1 batches=2000 batch_size=2048 total_batches=2000 elapsed=2.098s batches/s=953 points/s=1952245
```

## Итог

- Все release-пакетные тесты и release-бенчмарки, аналогичные `TESTS.md`, успешно пройдены.
- `if97_loadtest`, `grpc_healthcheck` и `grpc_loadtest` были действительно выполнены, а не только собраны.
- В прогоне не было падений из-за зависимости, сети или сокетов.
