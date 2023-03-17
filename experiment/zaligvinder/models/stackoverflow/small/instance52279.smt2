;test regex r"([A-Z][\w\-]+ )?\((\D*\d{4}(: ?[\d\-]*)*(, \d{4}(: ?[\d\-]*)*)*;?)*\)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.++ (re.range "A" "Z") (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-"))) (str.to_re " ")))) (re.++ (str.to_re "(") (re.++ (re.* (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.* (re.++ (str.to_re ":") (re.++ (re.opt (str.to_re " ")) (re.* (re.union (re.range "0" "9") (str.to_re "-")))))) (re.++ (re.* (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.++ (str.to_re ":") (re.++ (re.opt (str.to_re " ")) (re.* (re.union (re.range "0" "9") (str.to_re "-")))))))))) (re.opt (str.to_re ";"))))))) (re.++ (str.to_re ")") (str.to_re "\u{22}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)