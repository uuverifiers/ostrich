(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (not (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}")))))
; ^([a-zA-Z0-9]{1,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 15) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^\d{3}\s?\d{3}\s?\d{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fsearchfast\x2Fhoroscope2libManager\x2Edll\x5EgetFreeAccessBarHost\x3Ahostiedesksearch\.dropspam\.com
(assert (str.in_re X (str.to_re "/searchfast/horoscope2libManager.dll^getFreeAccessBarHost:hostiedesksearch.dropspam.com\u{0a}")))
; (NL-?)?[0-9]{9}B[0-9]{2}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "NL") (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
