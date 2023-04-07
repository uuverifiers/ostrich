;test regex \w*[^aeiou]{3,}\w*\n
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "e")) (re.inter (re.diff re.allchar (str.to_re "i")) (re.inter (re.diff re.allchar (str.to_re "o")) (re.diff re.allchar (str.to_re "u"))))))) ((_ re.loop 3 3) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "e")) (re.inter (re.diff re.allchar (str.to_re "i")) (re.inter (re.diff re.allchar (str.to_re "o")) (re.diff re.allchar (str.to_re "u")))))))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re "\u{0a}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)