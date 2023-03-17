;test regex '/[\/|\?|\&]([a-zA-Z\_0-9]+)([\/|=]([0-9]+)){0,1}/'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "/") (re.union (str.to_re "|") (re.union (str.to_re "?") (re.union (str.to_re "|") (str.to_re "&"))))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "_") (re.range "0" "9"))))) (re.++ ((_ re.loop 0 1) (re.++ (re.union (str.to_re "/") (re.union (str.to_re "|") (str.to_re "="))) (re.+ (re.range "0" "9")))) (re.++ (str.to_re "/") (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)