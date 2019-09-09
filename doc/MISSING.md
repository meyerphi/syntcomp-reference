# Unverified implementations

For the following reference implementations, the model checker reaches the
timeout of one hour when verifying the implementation:

- `amba_case_study_3`
- `detector_12`
- `full_arbiter_7`
- `full_arbiter_8`
- `full_arbiter_10`
- `full_arbiter_12`
- `full_arbiter_enc_6`
- `full_arbiter_enc_8`
- `full_arbiter_enc_10`
- `full_arbiter_enc_12`
- `genbuf4`
- `genbuf5`
- `generalized_buffer_4`
- `generalized_buffer_5`
- `generalized_buffer_6`
- `ltl2dba_C2_12`
- `ltl2dba_Q_12`
- `narylatch_12`

Of these, `detector_12`, `ltl2dba_C2_12`, `ltl2dba_Q_12` and `narylatch_12` can
be verified using the tool `iimc`, which is however known to be unsound in
general. `ltl2dba_Q_12` can also be verified within 3 hours using `nuXmv`.

Further, for all of these implementations, no counterexamples were found on a
run with a timelimit of 20 hours using `nuXmv` and when using the bounded model
checker `aigbmc` with a depth of 20.  This gives a high confidence that these
implementations are actually correct.

Still, in the future, the tool `nuXmv` should be replaced with a model
checker that is sound and can hopefully verify all implementations.
