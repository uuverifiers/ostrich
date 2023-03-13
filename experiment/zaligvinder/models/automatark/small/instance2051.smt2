(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Frss\d+answer\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
; ^([A-z]{2}\d{7})|([A-z]{4}\d{10})$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.range "A" "z")) ((_ re.loop 10 10) (re.range "0" "9"))))))
(check-sat)
