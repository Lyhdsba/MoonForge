# Reproducible benchmark workloads

These workloads exercise the same public CLI that reviewers use. They measure
four graph shapes rather than reporting synthetic function timings:

| Workload | Tasks | Shape | What it stresses |
| --- | ---: | --- | --- |
| small-chain | 12 | linear | first-run planning and cache hit |
| medium-mixed | 48 | six leaves plus a chain | mixed dependency levels |
| wide-fanout | 33 | 32 independent leaves | bounded parallel scheduling |
| deep-chain | 40 | linear | recursive planning depth |

Run from the repository root:

~~~powershell
powershell -ExecutionPolicy Bypass -File scripts\run_benchmarks.ps1 -Jobs 4
~~~

The script generates ignored fixtures under benchmarks/generated/, runs a cold
build and a warm cached build for every case, and writes CSV data to
benchmarks/results/latest.csv. The CLI also prints task-level execution
metrics, including executed/skipped counts, cache-hit percentage, total time,
and the longest task. Wall-clock values are machine-dependent; task counts and
cold/warm execution behavior are the portable acceptance signals.

The workload graph generator used by the MoonBit tests is in
benchmark_workloads.mbt; benchmark_workloads_wbtest.mbt verifies task counts,
depth, level grouping, and deterministic generation.
