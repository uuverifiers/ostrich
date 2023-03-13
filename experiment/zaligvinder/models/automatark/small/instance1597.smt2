(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+\x2FNFO\x2CRegisteredDeletingadfsgecoiwnf
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/NFO,RegisteredDeletingadfsgecoiwnf\u{1b}\u{0a}"))))
; (^\d{3,4}\-\d{4}$)|(^\d{7,8}$)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
