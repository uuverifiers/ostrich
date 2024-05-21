; Example that previously led to an exception using the full 2AFA pipeline

(set-logic QF_S)

(assert (str.in_re "P{Lowercase_Letter}" (re.from_ecma2020 '\P{Lowercase_Letter}')))

(check-sat)
