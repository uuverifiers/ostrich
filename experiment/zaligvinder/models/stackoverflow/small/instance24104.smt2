;test regex \d{2}(^40?|^41?|^43?)\d{6}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.union (re.++ (str.to_re "") (re.opt (str.to_re "40"))) (re.++ (str.to_re "") (re.opt (str.to_re "41")))) (re.++ (str.to_re "") (re.opt (str.to_re "43")))) ((_ re.loop 6 6) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)