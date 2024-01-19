;test regex ^[-]{5}[A-Z]{3,5}\sPGP\sMESSAGE[-]{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 5 5) (str.to_re "-")) (re.++ ((_ re.loop 3 5) (re.range "A" "Z")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "P") (re.++ (str.to_re "G") (re.++ (str.to_re "P") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "A") (re.++ (str.to_re "G") (re.++ (str.to_re "E") ((_ re.loop 5 5) (str.to_re "-"))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)