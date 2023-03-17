;test regex (r'^(((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?))')
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "r") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9"))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))))) (str.to_re "."))) (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9"))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (re.opt (re.range "0" "9")))))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)