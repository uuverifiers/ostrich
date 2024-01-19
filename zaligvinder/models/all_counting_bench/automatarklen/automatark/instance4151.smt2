(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[0-9]+\.d{3}? *$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (str.to_re "d")) (re.* (str.to_re " ")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
