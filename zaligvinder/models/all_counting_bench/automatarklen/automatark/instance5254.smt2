(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; replace(MobileNo,' ',''),'^(\+44|0044|0)(7)[4-9][0-9]{8}$'
(assert (str.in_re X (re.++ (str.to_re "replaceMobileNo,' ','','") (re.union (str.to_re "+44") (str.to_re "0044") (str.to_re "0")) (str.to_re "7") (re.range "4" "9") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "'\u{0a}"))))
; (\b\w+\b)       # Match a word and capture it
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "       # Match a word and capture it\u{0a}")))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (not (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
