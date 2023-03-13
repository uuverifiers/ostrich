;test regex (^\d{2,4}\\\d{6,8}$)|(^([a-zA-Z0-9_\.\-])+\@(([a-ZA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})$)|(\d{4}\.\d{4}\.\d{4})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.++ (str.to_re "\\") ((_ re.loop 6 8) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re ".") (str.to_re "-"))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "Z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (str.to_re "."))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))) (str.to_re ""))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)