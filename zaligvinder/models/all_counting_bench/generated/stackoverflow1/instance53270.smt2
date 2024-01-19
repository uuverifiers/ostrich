;test regex (WIF|DT|WT)\d{1,2}.?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "W") (re.++ (str.to_re "I") (str.to_re "F"))) (re.++ (str.to_re "D") (str.to_re "T"))) (re.++ (str.to_re "W") (str.to_re "T"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)