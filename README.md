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
- [nuXmv](https://es-static.fbk.eu/tools/nuxmv/index.php) model checker in version 2.0.0.
- [AIGER tools](http://fmv.jku.at/aiger/) with `aigtoaig` and `smvtoaig` binary.
- [GNU Parallel](https://www.gnu.org/software/parallel/).

### Running the verification process

To start the verification process for all specifications, simply run
```
./verify_all.sh <TIMELIMIT>
```
where `<TIMELIMIT>` should be the time limit for the verification in seconds.
The results will be output into the file `results.csv`.

The results of a run on a machine equipped with an Intel Core i7-4810MQ CPU
and 16 GB of memory and with a time limit of three hours are given in
[`results_verification.csv`](results_verification.csv)
The results of an older run with a monolithic composition are given in
[`results_verification_monolithic.csv`](results_verification_monolithic.csv)

To simply collect all combined files for model checking with a different tool,
one can call the script with time limit 0:
```
./verify_all.sh 0
```
The combined files will then be output into the folder `combined`.

### Verification results

Currently, almost all implementations can be verified within the time limit.
The few that cannot be verified directly using the default method can be
verified using alternative means, for this see the
[list of unverified implementations](doc/UNVERIFIED.md).

## Adding new reference implementations

New reference implementations that improve upon the existing ones are always
welcome. Further, some implementations are not yet minimal or it is unknown
whether their size is minimal, for more info see the
[notes on minimal sizes](doc/MINIMAL.md).

## Remarks on specifications

The specification `simple_arbiter_2.tlsf` in previous SYNTCOMP iterations had a
typo and used `n=3` in its parameter specification, making it equivalent to
`simple_arbiter_3.tlsf`. This is fixed in this selection of benchmarks, where
we use `n=2`. However this needs to be taken into account when comparing the
reference implementation to previous implementations from SYNTCOMP.

The specification `prioritized_arbiter_2.tlsf` in previous SYNTCOMP iterations
used `n=1` instead of `n=2`. Here, we use `n=2` in accordance to the other
instances and added a specification `prioritized_arbiter_1.tlsf` with `n=1`.

The specification `genbuf6.tlsf` has a typo in line 40, missing a `G` in the
second part of the assumption for `[spec_unit s2b_1]`, which makes the
specification unrealizable. This typo was left as it is, however now
the specification is different from `generalized_buffer_6.tlsf`.

## Implementation sources

Some implementations were obtained by past participants in the
[SYNTCOMP competition](http://www.syntcomp.org/), among them Strix, ltlsynt, BoSy, BoWSer, Party and Acacia.
The AIGER files were taken from the
[EDACC instance](https://syntcomp.react.uni-saarland.de/) for 2016-2018 and the
[StarExec folder](https://www.starexec.org/starexec/secure/explore/spaces.jsp?id=329383) for 2019-2020.
These implementations were also postprocessed by the [minimization](scripts/minimize.sh) and [stripping](scripts/strip.sh)
scripts of this repository.

Other implementations were written by hand, especially those for parameterized specifications for which also
an easy to construct parameterized implementation exists, or those for which there is a easy to find smaller
solution than any one constructed by the tools above.
