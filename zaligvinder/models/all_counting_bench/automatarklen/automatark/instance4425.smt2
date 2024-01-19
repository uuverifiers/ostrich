(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <img .+ src[ ]*=[ ]*\"(.+)\"
(assert (not (str.in_re X (re.++ (str.to_re "<img ") (re.+ re.allchar) (str.to_re " src") (re.* (str.to_re " ")) (str.to_re "=") (re.* (str.to_re " ")) (str.to_re "\u{22}") (re.+ re.allchar) (str.to_re "\u{22}\u{0a}")))))
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}"))))
; User-Agent\u{3a}Host\x3AHost\x3ASpyBuddy
(assert (not (str.in_re X (str.to_re "User-Agent:Host:Host:SpyBuddy\u{0a}"))))
; ^(b|B)(f|F)(p|P)(o|O)(\s*||\s*C(/|)O\s*)[0-9]{1,4}
(assert (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "C/O") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
