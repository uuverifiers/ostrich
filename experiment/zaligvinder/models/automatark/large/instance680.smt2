(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "F-")) (re.union (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "|") (str.to_re "B"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^\/\u{3f}[1-9][A-Za-z0-9~_-]{240}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?") (re.range "1" "9") ((_ re.loop 240 240) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "~") (str.to_re "_") (str.to_re "-"))) (str.to_re "/Ui\u{0a}")))))
(check-sat)
