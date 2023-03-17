;test regex ^(sip):\(?([0-9]{3})\)?[- ]?([0-9]{3})[- ]?([0-9]{4})@\w+(\ w+)*(\.\w)(\.\w{2,3})+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "p"))) (re.++ (str.to_re ":") (re.++ (re.opt (str.to_re "(")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re ")")) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.* (re.++ (str.to_re " ") (re.+ (str.to_re "w")))) (re.++ (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)