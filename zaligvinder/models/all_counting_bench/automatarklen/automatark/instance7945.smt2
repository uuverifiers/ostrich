(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[1-9]{1}[0-9]{1,5}-\d{2}-\d\b
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; [a-z]{1}[a-z0-9\-_\.]{2,24}@tlen\.pl
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (str.to_re "@tlen.pl\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
