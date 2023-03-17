;test regex ^:[0-7]{6} [0-7]{6} [0-9a-fA-F]{40} [0-9a-fA-F]{40} ([ACDMR])\d{0,3}\t(.+)(?:\t(.+))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re ":") (re.++ ((_ re.loop 6 6) (re.range "0" "7")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 6 6) (re.range "0" "7")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "M") (str.to_re "R"))))) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.++ (str.to_re "\u{09}") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.opt (re.++ (str.to_re "\u{09}") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)