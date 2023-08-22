(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?([1-9][0-9]{3,}(\.\d{2})?|(\d{1,3}\,\d{3}|\d{1,3}\,\d{3}(\.\d{2})?)|(\d{1,3}\,\d{3}|\d{1,3}\,\d{3}\,\d{3}(\.\d{2})?)*)?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.opt (re.union (re.++ (re.range "1" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.* (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))) (str.to_re "\u{0a}")))))
; (([0-1][0-9])|([2][0-3])):([0-5][0-9]):([0-5][0-9])
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
; X-Mailer\x3Acom\u{18}\u{16}dcww\x2Edmcast\x2EcomHost\x3Adist\x2Eatlas\x2Dia\x2Ecom
(assert (str.in_re X (str.to_re "X-Mailer:\u{13}com\u{18}\u{16}dcww.dmcast.comHost:dist.atlas-ia.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
