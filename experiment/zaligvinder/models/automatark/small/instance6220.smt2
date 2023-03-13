(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0]?[1-9]|[1][0-2])[./-]([0]?[1-9]|[1|2][0-9]|[3][0|1])[./-]([0-9]{4}|[0-9]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^([1-9]|1[0-2]|0[1-9]){1}(:[0-5][0-9][ ][aApP][mM]){1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9")))) ((_ re.loop 1 1) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (str.to_re "\u{0a}")))))
; /\/flupdate\/\d\.html/iU
(assert (str.in_re X (re.++ (str.to_re "//flupdate/") (re.range "0" "9") (str.to_re ".html/iU\u{0a}"))))
(check-sat)
