;test regex ^(?:[^_]*_){2}[^_0-9]*\K\d*\.?\d+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.++ (re.* (re.diff re.allchar (str.to_re "_"))) (str.to_re "_"))) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "_")) (re.diff re.allchar (re.range "0" "9")))) (re.++ (str.to_re "K") (re.++ (re.* (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)