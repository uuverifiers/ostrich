(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jpe/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpe/i\u{0a}")))))
; Host\x3A\s+\x2FNFO\x2CRegisteredDeletingadfsgecoiwnf
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/NFO,RegisteredDeletingadfsgecoiwnf\u{1b}\u{0a}"))))
(check-sat)
