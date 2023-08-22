;test regex (cat|dog)(?:\W+\w+){0,3}?\W+(cat|dog)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "t"))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "g")))) (re.++ ((_ re.loop 0 3) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "t"))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "g")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)