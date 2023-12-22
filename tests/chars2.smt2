(set-logic QF_)

(declare-fun x () String)

(assert (str.in.re x (re.range (str.from_code (bv2nat #x0b)) (str.from_code (bv2nat #xff)))))

(check-sat)
