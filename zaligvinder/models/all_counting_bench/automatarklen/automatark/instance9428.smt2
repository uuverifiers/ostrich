(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0]?[1-9]|1[0-2])/([0-2]?[0-9]|3[0-1])/[1-2]\d{3})? ?((([0-1]?\d)|(2[0-3])):[0-5]\d)?(:[0-5]\d)? ?(AM|am|PM|pm)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (re.range "0" "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (str.to_re " ")) (re.opt (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "PM") (str.to_re "pm"))) (str.to_re "\u{0a}"))))
; -[0-9]*[x][0-9]*
(assert (str.in_re X (re.++ (str.to_re "-") (re.* (re.range "0" "9")) (str.to_re "x") (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
