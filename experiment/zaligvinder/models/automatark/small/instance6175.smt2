(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}plp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.plp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
