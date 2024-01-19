;test regex ([wW]{3,3}\.|)[A-Za-z0-9]+?\.(se|com|ru)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.union (str.to_re "w") (str.to_re "W"))) (str.to_re "."))) (str.to_re "")) (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "s") (str.to_re "e")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))) (re.++ (str.to_re "r") (str.to_re "u"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)