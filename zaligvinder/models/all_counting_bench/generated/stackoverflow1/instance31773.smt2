;test regex (?:0x|\$)?[0-9a-f]{5,10}h?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "0") (str.to_re "x")) (str.to_re "$"))) (re.++ ((_ re.loop 5 10) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.opt (str.to_re "h"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)