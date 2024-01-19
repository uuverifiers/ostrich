(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^07([\d]{3})[(\D\s)]?[\d]{3}[(\D\s)]?[\d]{3}$
(assert (not (str.in_re X (re.++ (str.to_re "07") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ((0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)\.){3}(0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "."))) (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
