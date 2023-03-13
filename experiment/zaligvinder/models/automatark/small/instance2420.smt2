(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{1,2}d \d{1,2}h
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "d ") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h\u{0a}"))))
(check-sat)
