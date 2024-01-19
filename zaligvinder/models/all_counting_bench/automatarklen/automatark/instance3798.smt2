(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; ^(0|([1-9]\d{0,3}|[1-5]\d{4}|[6][0-5][0-5]([0-2]\d|[3][0-5])))$
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "5") (re.range "0" "5") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5"))))) (str.to_re "\u{0a}"))))
; ^([A-Z]{1}\w{1,3}) (\d{1}[A-Z]{2})$
(assert (str.in_re X (re.++ (str.to_re " \u{0a}") ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")))))
(assert (> (str.len X) 10))
(check-sat)
