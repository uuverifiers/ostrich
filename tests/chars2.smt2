(set-logic QF_)

(declare-fun x () String)

(assert (str.in.re x (re.range (seq.unit #x0b) (seq.unit #xff))))

(check-sat)
