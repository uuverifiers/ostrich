;test regex r"^([0-9_?]{7})(,[0-9_?]{7})*$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "r") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ ((_ re.loop 7 7) (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re "?")))) (re.* (re.++ (str.to_re ",") ((_ re.loop 7 7) (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re "?"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)