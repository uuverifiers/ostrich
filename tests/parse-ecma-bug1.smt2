(set-logic QF_S)

(set-option :produce-models true)

(declare-const w String)

(assert (str.in.re w (re.from_ecma2020 '[\)]')))

(check-sat)
(get-model)
