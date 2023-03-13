(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Mailer\x3Acom\u{18}\u{16}dcww\x2Edmcast\x2EcomHost\x3Adist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}com\u{18}\u{16}dcww.dmcast.comHost:dist.atlas-ia.com\u{0a}"))))
; /filename=[^\n]*\u{2e}pdf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pdf/i\u{0a}")))))
; /filename=[^\n]*\u{2e}xml/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xml/i\u{0a}")))))
; (0?[1-9]|[12][0-9]|3[01])[.](0?[1-9]|1[012])[.]\d{4}
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
