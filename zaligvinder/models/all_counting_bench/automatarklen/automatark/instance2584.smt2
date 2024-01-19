(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\(?\d{3}?\)?\-?\d{3}?\-?\d{4}?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}dvr-ms([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.dvr-ms") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
