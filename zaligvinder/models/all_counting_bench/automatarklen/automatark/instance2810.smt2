(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?catalogp\=\d{2}$/U
(assert (str.in_re X (re.++ (str.to_re "/.php?catalogp=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
