# SYNTCOMP reference implementations

This is a collection from specifications obtained from the TLSF/LTL track
of the [Reactive Synthesis Competition (SYNTCOMP)](http://www.syntcomp.org/),
together with reference implementations verifying realizability/unrealizability
of most specifications. Scripts are provided for verifying the implementations
and additionally a few utility scripts for inspecting them.

## Verifying the circuits

### Dependencies for verification

- [SyfCo](https://github.com/reactive-systems/syfco) for TLSF conversion.
- [combine-aiger](https://github.com/meyerphi/combine-aiger) for combining specification and implementation.
- [NuSMV](http://nusmv.fbk.eu/index.html) with `ltl2smv` binary.
- [nuXmv](https://es-static.fbk.eu/tools/nuxmv/index.php) model checker.
- [AIGER tools](http://fmv.jku.at/aiger/) with `aigtoaig` and `smvtoaig` binary.

### Running the verification process

To start the verification process for all specifications, simply run
```
./verify_all <TIMELIMIT>
```
where `<TIMELIMIT>` should be the time limit for the verification in seconds.
The results will be output into the file `results.csv`.

The results of a run on a machine equipped with an Intel Core i7-4810MQ CPU
and 16 GB of memory and with a timeout of one hour are given in
[`results_verification.csv`](results_verification.csv)

## Adding new reference implementations

New reference implementations that improve upon the existing ones are always
welcome. First, several specifications do not yet have any verified reference
implementation, for that see the
[list of missing implementations](doc/MISSING.md).
Further, some implementations are not yet
minimal or it is unknown whether their size is minimal, for further info
see the [notes on minimal sizes](doc/MINIMAL.md).

Finally, some verifications are already very small, but cannot be verified
within a reasonable amount of time. Here, either a more efficient model checker
or more work on how to help the model checker to verify the implementation is
needed.

## Remarks

The specification `simple_arbiter_2.tlsf` in previous SYNTCOMP iterations had a
typo and used `n=3` in its parameter specification, making it equivalent to
`simple_arbiter_3.tlsf`. This is fixed in this selection of benchmarks, where
we use `n=2`. However this needs to be taken into account when comparing the
reference implementation to previous implementations from SYNTCOMP.
