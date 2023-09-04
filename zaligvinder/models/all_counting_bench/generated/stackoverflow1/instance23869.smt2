;test regex [0-9\-_]*[s|c]{1}[0-9_]+
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_")))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "s") (re.union (str.to_re "|") (str.to_re "c")))) (re.+ (re.union (re.range "0" "9") (str.to_re "_")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)