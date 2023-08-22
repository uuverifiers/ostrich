(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([01][0-9][0-9]|2[0-4][0-9]|25[0-5].[01][0-9][0-9]|2[0-4][0-9]|25[0-5].[01][0-9][0-9]|2[0-4][0-9]|25[0-5].[01][0-9][0-9]|2[0-4][0-9]|25[0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
; /\u{2f}b\u{2f}shoe\u{2f}[0-9]{3,5}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/shoe/") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
