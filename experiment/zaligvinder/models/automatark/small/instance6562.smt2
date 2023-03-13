(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\/flupdate\/\d\.html/iU
(assert (not (str.in_re X (re.++ (str.to_re "//flupdate/") (re.range "0" "9") (str.to_re ".html/iU\u{0a}")))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}")))))
(check-sat)
