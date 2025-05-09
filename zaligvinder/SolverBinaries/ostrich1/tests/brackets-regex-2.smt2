(set-logic QF_S)

(declare-const w String)
(declare-const x Int)

(assert (= (* x x) 10))
(assert (str.in.re w (re.from.str "<script>X</script>")))
(assert (str.in.re w (re.from.str "[<>X].*")))

(check-sat)
