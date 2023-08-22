(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w ]{0,}$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^[A-Za-z]{3,4}[ |\-]{0,1}[0-9]{6}[ |\-]{0,1}[0-9A-Za-z]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
