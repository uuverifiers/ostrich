(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(010|011|012)[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}01") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))))))
; /\u{2e}jpeg([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpeg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
