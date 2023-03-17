;test regex \u{67}\u{45}\u{00}\u{00}([^\xFF]{30})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{67}") (re.++ (str.to_re "\u{45}") (re.++ (str.to_re "\u{00}") (re.++ (str.to_re "\u{00}") ((_ re.loop 30 30) (re.diff re.allchar (str.to_re "\u{ff}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)