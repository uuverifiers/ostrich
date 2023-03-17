;test regex [A-Za-z]{1,3}:?-?\d?b?a?r?
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (str.to_re ":")) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (re.range "0" "9")) (re.++ (re.opt (str.to_re "b")) (re.++ (re.opt (str.to_re "a")) (re.opt (str.to_re "r"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)