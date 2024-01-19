(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [^"\r\n]*
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{22}") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}")))))
; ^(|(0\d)|(1[0-2])):(([0-5]\d)):(([0-5]\d))\s([AP]M)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "::") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "P")) (str.to_re "M")))))
; ^(\d{1}|\d{2}|\d{3})(\.\d{3})*?$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Subject\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (str.to_re "Subject:as.starware.com/dp/search?x=\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
