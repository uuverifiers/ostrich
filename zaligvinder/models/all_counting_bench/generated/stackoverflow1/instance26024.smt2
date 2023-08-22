;test regex ^(\d{4}\-\d\d\-\d\d([tT][\d:\.]*)?)([zZ]|([+\-])(\d{3}))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.opt (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.* (re.union (re.range "0" "9") (re.union (str.to_re ":") (str.to_re "."))))))))))))) (re.opt (re.union (re.union (str.to_re "z") (str.to_re "Z")) (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)