(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}\u{29}url=http\x3A1\x2E0b3\x2EaspxWatchDogupwww\.klikvipsearch\.comNetspyt=WeHost\x3A\x2Fcgi\x2Flogurl\.cgi
(assert (not (str.in_re X (str.to_re "()url=http:\u{1b}1.0b3.aspxWatchDogupwww.klikvipsearch.comNetspyt=WeHost:/cgi/logurl.cgi\u{0a}"))))
; ^(\d{1,3}'(\d{3}')*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "'") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "'"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(check-sat)
