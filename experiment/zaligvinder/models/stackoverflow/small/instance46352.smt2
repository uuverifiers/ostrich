;test regex /^[A-Z0-9]{3,6}/[0-9]{2}[ \t]+VALID:.*(\r?\n[ \t]+.*)+/mg
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ ((_ re.loop 3 6) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (str.to_re "V") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re ":") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.+ (re.++ (re.opt (str.to_re "\u{0d}")) (re.++ (str.to_re "\u{0a}") (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))) (re.++ (str.to_re "/") (re.++ (str.to_re "m") (str.to_re "g")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)