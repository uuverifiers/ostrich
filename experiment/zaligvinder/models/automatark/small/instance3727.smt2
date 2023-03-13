(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-f0-9]{32}\.jar/
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/\u{0a}"))))
; Basic\s+news\s+CD\x2Furl=Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Basic") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CD/url=Host:\u{0a}")))))
; ^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; \x2Fbar_pl\x2Fchk\.fcgiHWAEcom\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re "/bar_pl/chk.fcgiHWAEcom/index.php?tpid=\u{0a}"))))
(check-sat)
