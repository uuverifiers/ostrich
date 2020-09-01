(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "<script>X</script>")))
(assert (str.in.re w (re.from.str "[<>X].*")))

(check-sat)
