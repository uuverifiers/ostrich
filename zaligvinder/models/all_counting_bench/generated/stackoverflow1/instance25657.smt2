;test regex ^[NY]\|\d{5}\|(?:[\w_]+[^\u{00}-\x7F]?[\w_]+\|){2}(?:[\w_]+[\u{00}-\x7F]?[\w_]+\|){2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "N") (str.to_re "Y")) (re.++ (str.to_re "|") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "|") (re.++ ((_ re.loop 2 2) (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "_"))) (re.++ (re.opt (re.diff re.allchar (re.range "\u{00}" "\u{7f}"))) (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "_"))) (str.to_re "|"))))) ((_ re.loop 2 2) (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "_"))) (re.++ (re.opt (re.range "\u{00}" "\u{7f}")) (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "_"))) (str.to_re "|"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)