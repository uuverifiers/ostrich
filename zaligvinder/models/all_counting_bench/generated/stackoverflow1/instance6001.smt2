;test regex (?:[a-zA-Z]+)?([^aeiou,.\s]{2,3}[a-zA-Z]+)/g
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.++ ((_ re.loop 2 3) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "e")) (re.inter (re.diff re.allchar (str.to_re "i")) (re.inter (re.diff re.allchar (str.to_re "o")) (re.inter (re.diff re.allchar (str.to_re "u")) (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re ".")) (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}"))))))))))))))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "/") (str.to_re "g"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)