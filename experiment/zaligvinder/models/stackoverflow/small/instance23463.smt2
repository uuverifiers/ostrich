;test regex (([01]?\\d{1,2}|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d{1,2}|2[0-4]\\d|25[0-5])
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.union (re.++ (re.opt (str.to_re "01")) (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))))) (re.union (re.union (re.++ (re.opt (str.to_re "01")) (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (str.to_re "25") (re.range "0" "5"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)