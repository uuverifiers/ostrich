(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?java\=[0-9]{2,6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/?java=") ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(check-sat)
