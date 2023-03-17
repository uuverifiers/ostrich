;test regex ^((?:\D+(?:\d?\D*){0,7})|(?:[1-9]\D*(?:\d?\D*){0,6}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) ((_ re.loop 0 7) (re.++ (re.opt (re.range "0" "9")) (re.* (re.diff re.allchar (re.range "0" "9")))))) (re.++ (re.range "1" "9") (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) ((_ re.loop 0 6) (re.++ (re.opt (re.range "0" "9")) (re.* (re.diff re.allchar (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)