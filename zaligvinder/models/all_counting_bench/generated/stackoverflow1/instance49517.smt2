;test regex (?:(?:\d{4}[- ])?\d{4})(?: \(\d+ months\))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.opt (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "s") (str.to_re ")"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)