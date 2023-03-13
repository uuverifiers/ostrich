(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eonlinecasinoextra\x2Ecom\s+
(assert (not (str.in_re X (re.++ (str.to_re "www.onlinecasinoextra.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^[D-d][K-k]-[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; url=http\x3A\s+jsp[^\n\r]*serverHOST\x3ASubject\x3Ai\-femdom\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "url=http:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jsp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "serverHOST:Subject:i-femdom.com\u{0a}")))))
(check-sat)
