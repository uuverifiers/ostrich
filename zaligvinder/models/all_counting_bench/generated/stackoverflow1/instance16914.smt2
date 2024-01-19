;test regex (\<div\>\w+\:?\s+?\</div\> )|\$?(\d+).(\d{1,3})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "<") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re ">") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.opt (str.to_re ":")) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re ">") (str.to_re " "))))))))))))))) (re.++ (re.opt (str.to_re "$")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 3) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)