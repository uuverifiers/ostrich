(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[0-9A-F]{24}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Ui\u{0a}")))))
; .*\$AVE|\$ave.*
(assert (not (str.in_re X (re.union (re.++ (re.* re.allchar) (str.to_re "$AVE")) (re.++ (str.to_re "$ave") (re.* re.allchar) (str.to_re "\u{0a}"))))))
; version\s+error\*\-\*WrongUser-Agent\x3Acom\x2Findex\.php\?tpid=
(assert (str.in_re X (re.++ (str.to_re "version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "error*-*WrongUser-Agent:com/index.php?tpid=\u{0a}"))))
; \$(\d)*\d
(assert (str.in_re X (re.++ (str.to_re "$") (re.* (re.range "0" "9")) (re.range "0" "9") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
