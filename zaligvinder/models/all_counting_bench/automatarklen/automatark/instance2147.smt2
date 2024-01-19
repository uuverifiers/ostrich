(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(00356)?(99|79|77|21|27|22|25)[0-9]{6}/g
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "00356")) (re.union (str.to_re "99") (str.to_re "79") (str.to_re "77") (str.to_re "21") (str.to_re "27") (str.to_re "22") (str.to_re "25")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "/g\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
