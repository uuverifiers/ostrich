;test regex Z[R|S|T|U][0-9][A-Z]{1,}(\-)?([0-9]{1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "Z") (re.++ (re.union (str.to_re "R") (re.union (str.to_re "|") (re.union (str.to_re "S") (re.union (str.to_re "|") (re.union (str.to_re "T") (re.union (str.to_re "|") (str.to_re "U"))))))) (re.++ (re.range "0" "9") (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z"))) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)