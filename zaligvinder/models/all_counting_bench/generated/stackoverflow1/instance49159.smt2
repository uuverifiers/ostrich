;test regex (\\d+?) <([A-Z]+?)> (:?(\\d+?) ){3,4}(</[A-Z]+?>)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (re.+ (re.range "A" "Z")) (re.++ (str.to_re ">") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 4) (re.++ (re.opt (str.to_re ":")) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (str.to_re " ")))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (re.+ (re.range "A" "Z")) (str.to_re ">")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)