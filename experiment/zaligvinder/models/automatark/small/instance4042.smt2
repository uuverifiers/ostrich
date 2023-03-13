(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{2}?(\d{7}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9"))))))
; /filename=[a-z]{5,8}\d{2,3}\.swf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".swf\u{0d}\u{0a}/Hm\u{0a}"))))
(check-sat)
