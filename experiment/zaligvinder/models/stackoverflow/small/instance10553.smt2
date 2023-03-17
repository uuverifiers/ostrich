;test regex ((1{0,1}[012]{1})|[0-9]{1}){1}((:|\s)?[0-5]{1}[0-9]{1})?((a|p|A|P){1}(m|M){1})?
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ ((_ re.loop 0 1) (str.to_re "1")) ((_ re.loop 1 1) (str.to_re "012"))) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ (re.opt (re.++ (re.opt (re.union (str.to_re ":") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9"))))) (re.opt (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (str.to_re "a") (str.to_re "p")) (str.to_re "A")) (str.to_re "P"))) ((_ re.loop 1 1) (re.union (str.to_re "m") (str.to_re "M")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)