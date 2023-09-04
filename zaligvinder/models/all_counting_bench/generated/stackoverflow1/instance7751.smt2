;test regex ((\d{1,2}|\d{4})(.\d{1,2}))(am|pm)*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (re.union (re.++ (str.to_re "a") (str.to_re "m")) (re.++ (str.to_re "p") (str.to_re "m")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)