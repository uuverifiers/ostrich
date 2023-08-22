;test regex '(?:(.+)?\w+(.+)? ){5}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 5 5) (re.++ (re.opt (re.+ (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.opt (re.+ (re.diff re.allchar (str.to_re "\n")))) (str.to_re " "))))) (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)