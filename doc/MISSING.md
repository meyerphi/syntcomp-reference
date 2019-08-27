# Missing reference implementations

For some specifications, there is yet no reference implemenation.

### Realizable specifications:

- `amba_case_study_3`
- `full_arbiter_10`
- `full_arbiter_12`
- `full_arbiter_enc_10`
- `full_arbiter_enc_12`
- `genbuf3`
- `genbuf4`
- `genbuf5`
- `genbuf6`
- `generalized_buffer_3`
- `generalized_buffer_4`
- `generalized_buffer_5`
- `generalized_buffer_6`

### Unrealizable specifications:

- `ModdifiedLedMatrix4X`

# Unverified implementations

For the following reference implementations, the model checker reaches the
timeout of one hour when verifying the implementation:

- `detector_12`
- `full_arbiter_7`
- `full_arbiter_8`
- `full_arbiter_enc_6`
- `full_arbiter_enc_8`
- `ltl2dba_C2_12`
- `ltl2dba_Q_12`
- `narylatch_12`

Of these, `detector_12`, `ltl2dba_C2_12`, `ltl2dba_Q12` and `narylatch_12` can
be verified using the tool `iimc`, which is however known to be unsound in
general. In the future, the tool `nuXmv` should be replaced with a model
checker that is sound and can hopefully verify all implementation.
