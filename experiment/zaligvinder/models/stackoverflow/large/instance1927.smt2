;test regex ^(?:[a-fA-F\d]{32,40})$|^(?:[a-fA-F\d]{52,60})$|^(?:[a-fA-F\d]{92,100})$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") ((_ re.loop 32 40) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") ((_ re.loop 52 60) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 92 100) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)