;test regex ^#(http.+.\w{3,4}.+)?_surveyForm=(\w+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "#") (re.++ (re.opt (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 3 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))) (re.++ (str.to_re "_") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re "F") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "m") (re.++ (str.to_re "=") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)