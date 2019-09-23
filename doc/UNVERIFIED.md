# Unverified implementations

For the following reference implementations, the model checker reaches the
time limit of three hours when verifying the implementation:

- `detector_12`
- `ltl2dba_C2_12`
- `narylatch_12`

These three can be verified using the tool `iimc`, which is however known to be
unsound in general. They can also be verified with `nuXmv` if the specification
is rewritten with a top-level conjunction, which can then be split. Further, no
counterexamples were found on a run with a time limit of 20 hours using `nuXmv`
and when using the bounded model checker `aigbmc` with a depth of 40. This
gives a high confidence that these implementations are actually correct.

Still, in the future, the tool `nuXmv` should be replaced with a model checker
that is sound and can hopefully verify all implementations. Instead of using a
hardware model checker that only sees the combined circuit, it seems advisable
to exploit some structure in the LTL formula, either by preprocessing or by
using an explicit LTL model checker.
