(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)|(^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{11})$)
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9"))))))
; .*[\$Ss]pecia[l1]\W[Oo0]ffer.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "$") (str.to_re "S") (str.to_re "s")) (str.to_re "pecia") (re.union (str.to_re "l") (str.to_re "1")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "O") (str.to_re "o") (str.to_re "0")) (str.to_re "ffer") (re.* re.allchar) (str.to_re "\u{0a}")))))
; www\u{2e}2-seek\u{2e}com\u{2f}searchUser-Agent\u{3a}
(assert (str.in_re X (str.to_re "www.2-seek.com/searchUser-Agent:\u{0a}")))
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h"))))))
(check-sat)
