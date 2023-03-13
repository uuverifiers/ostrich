(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wri/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wri/i\u{0a}")))))
; ^([30|36|38]{2})([0-9]{12})$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "3") (str.to_re "0") (str.to_re "|") (str.to_re "6") (str.to_re "8"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
