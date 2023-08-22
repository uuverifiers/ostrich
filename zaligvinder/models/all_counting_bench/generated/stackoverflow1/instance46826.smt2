;test regex r"^(([a-zA-Z-]+)(__?)){1,3}(\d+).(\d+).(\d+).xlsx"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "r") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ ((_ re.loop 1 3) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re "-")))) (re.++ (str.to_re "_") (re.opt (str.to_re "_"))))) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "x") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (re.++ (str.to_re "x") (str.to_re "\u{22}"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)