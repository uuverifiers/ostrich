;test regex ^(?:[^,\n]*,){2}[^,\n]*\K,1,
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re ","))) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "K")))) (re.++ (str.to_re ",") (str.to_re "1"))) (str.to_re ","))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)