;test regex [JKL]{1}[DEF]{1}[DEF]{1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "J") (re.union (str.to_re "K") (str.to_re "L")))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F")))) ((_ re.loop 1 1) (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)