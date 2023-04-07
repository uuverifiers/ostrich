;test regex ([#.](?:[\w-]|\\(?:[A-Fa-f0-9]{1,6} ?|[^A-Fa-f0-9]))+)\s*\(
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "#") (str.to_re ".")) (re.+ (re.union (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-")) (re.++ (str.to_re "\\") (re.union (re.++ ((_ re.loop 1 6) (re.union (re.range "A" "F") (re.union (re.range "a" "f") (re.range "0" "9")))) (re.opt (str.to_re " "))) (re.inter (re.diff re.allchar (re.range "A" "F")) (re.inter (re.diff re.allchar (re.range "a" "f")) (re.diff re.allchar (re.range "0" "9"))))))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re "(")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)