(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/images\/[a-zA-Z]\.php\?id\=[0-9]{2,3}(\.\d)?$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//images/") (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ".php?id=") ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
; \x2Fpagead\x2Fads\?\d+ocllceclbhs\u{2f}gth
(assert (not (str.in_re X (re.++ (str.to_re "/pagead/ads?") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}")))))
; /filename=[^\n]*\u{2e}wk4/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wk4/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
