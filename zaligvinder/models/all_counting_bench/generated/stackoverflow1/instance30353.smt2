;test regex ^(?:(?:1?\d{1,4}|20[0-3]\d\d|204[0-6]\d|2047[0-8])(?:\.\d+)?|20479(?:\.0+)?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.union (re.union (re.++ (re.opt (str.to_re "1")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (str.to_re "20") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (str.to_re "204") (re.++ (re.range "0" "6") (re.range "0" "9")))) (re.++ (str.to_re "2047") (re.range "0" "8"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (str.to_re "20479") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)