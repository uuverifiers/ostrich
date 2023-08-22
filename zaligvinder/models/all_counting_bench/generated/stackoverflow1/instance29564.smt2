;test regex ^(\d{1,3}) +((?:[a-zA-Z0-9\(\)\-,]+ )+) + *((?:[\d]  {1,4}|\d)+)([ \d]+)?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.+ (str.to_re " ")) (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "-") (str.to_re ",")))))))) (str.to_re " "))) (re.++ (re.+ (str.to_re " ")) (re.++ (re.* (str.to_re " ")) (re.++ (re.+ (re.union (re.++ (re.range "0" "9") (re.++ (str.to_re " ") ((_ re.loop 1 4) (str.to_re " ")))) (re.range "0" "9"))) (re.opt (re.+ (re.union (str.to_re " ") (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)