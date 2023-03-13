(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\r\n\r\nsession\u{3a}\d{1,7}$/
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}\u{0d}\u{0a}session:") ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
; /\/stat_svc\/$/U
(assert (not (str.in_re X (str.to_re "//stat_svc//U\u{0a}"))))
(check-sat)
