(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Subject\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:as.starware.com/dp/search?x=\u{0a}")))))
; /gate\u{2e}php\u{3f}id=[a-z]{15}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?id=") ((_ re.loop 15 15) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
(check-sat)
