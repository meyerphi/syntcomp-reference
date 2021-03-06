# Sizes of minimal implementations

The goal of this repository is to find implementations of minimal size for all
SYNTCOMP specifications. Unfortunately, finding the minimal implementation is a
hard problem and verifying if an implementation is indeed the smallest one is
also hard (unless the size is already 0). However, one can still find small
implementations by best effort. Further, for some implementations it might be
possibly to very that they are the smallest ones, e.g. by enumeration and
verification of all smaller implementations.

## Large implementations

Some specifications only have a large implementation so far that can quite
possibly be improved. Here is a list based on a threshold of size 120:

- `KitchenTimerV5`: 387
- `KitchenTimerV6`: 387
- `KitchenTimerV7`: 387
- `KitchenTimerV8`: 423
- `KitchenTimerV9`: 423
- `KitchenTimerV10`: 423

## Parameterized specifications

Several of the specifications from SYNTCOMP are parameterized by a parameter *n*,
and for these, one can usually also find a parameterized implementation sharing
the same structure by following a certain construction scheme. Here, a list
of the sizes of these parameterized implementations depending on *n* is given.

Note that these are all only upper bounds on the size of the minimal
implementation. Some may also only be optimal asymptotically, as often there
is already a smaller implementation for small values of *n*. For
implementations with a logarithmic component, often the exact constants are yet
unknown and only *O(log2(n))* is given. Here, *log2(n)* is the logarithm of *n*
to the basis 2, rounded up.

Specification | Latches | And gates
--- | ---: | ---:
`amba_case_study_`*n* | *3n+9* | *17n+24*
`amba_decomposed_arbiter_`*n* | *n+1* | *6n+6*
`amba_decomposed_encode_`*n* | *log2(n)* | *n+3log2(n)*
`amba_decomposed_lock_`*n* | *2* | *2n+2*
`collector_v1_`*n* | *n* | *3n-1*
`collector_v2_`*n* | *n* | *3n*
`collector_v3_`*n* | *0* | *0*
`collector_v4_`*n* | *n* | *3n*
`detector_`*n* | *n* | *3n*
`full_arbiter_`*n* | *2n* | *3n*
`full_arbiter_enc_`*n* | *2n+2* | *7n+O(log2(n)+log2(n+1))*
`generalized_buffer_`*n* | *2n+3* | *4n+2*
`load_balancer_`*n* | *2n-1* | *5n-5*
`ltl2dba_alpha_`*n* (linear) | *n+1* | *n+2*
`ltl2dba_alpha_`*n* (binary) | *O(log2(n+1))* | *O(log2(n+1))*
`ltl2dba_beta_`*n* | *2n* | *4n-1*
`ltl2dba_C1_`*n* | *0* | *n-1*
`ltl2dba_C2_`*n* | *n* | *3n*
`ltl2dba_E_`*n* | *n* | *2n-1*
`ltl2dba_psi_`*n* | *1* | *0*
`ltl2dba_Q_`*n* | *2n-1* | *4n-3*
`ltl2dba_R_`*n* | *1* | *0*
`ltl2dba_S_`*n* | *n* | *2n-1*
`ltl2dba_U1_`*n* | *n* | *3n-2*
`ltl2dba_U2_`*n* | *n* | *2n-1*
`nary_latch_`*n* | *n* | *3n*
`mux_`*n* | *0* | *0*
`prioritized_arbiter_`*n* | *n+1* | *3n*
`prioritized_arbiter_enc_`*n* | *n+3* | *5n+O(log2(n)+log2(n+1))*
`round_robin_arbiter_`*n* | *n* | *0*
`shift_`*n* | *0* | *0*
`simple_arbiter_`*n* | *n* | *0*
`simple_arbiter_enc_`*n* | *n+1* | *2n+O(log2(n))*
