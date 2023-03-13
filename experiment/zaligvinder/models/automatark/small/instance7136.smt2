(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}htc([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.htc") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^\d{3,3}\.\d{0,2}$|^E\d{3,3}\.\d{0,2}$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "E") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; BasicPointsHost\x3Anews
(assert (str.in_re X (str.to_re "BasicPointsHost:news\u{0a}")))
(check-sat)
