;test regex \d{19}_\d+_\d_[A-Z]?_\d{4}(-\d{2}){2}_(-?\d{2})+\.db
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 19 19) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ (re.opt (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "_") (re.++ (re.+ (re.++ (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "d") (str.to_re "b")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)