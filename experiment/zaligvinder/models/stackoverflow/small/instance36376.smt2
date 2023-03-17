;test regex [Hh]{1,}[Ee]{1,}[Ll]{1,}[Oo]{1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (str.to_re "H") (str.to_re "h"))) ((_ re.loop 1 1) (re.union (str.to_re "H") (str.to_re "h")))) (re.++ (re.++ (re.* (re.union (str.to_re "E") (str.to_re "e"))) ((_ re.loop 1 1) (re.union (str.to_re "E") (str.to_re "e")))) (re.++ (re.++ (re.* (re.union (str.to_re "L") (str.to_re "l"))) ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "l")))) (re.++ (re.* (re.union (str.to_re "O") (str.to_re "o"))) ((_ re.loop 1 1) (re.union (str.to_re "O") (str.to_re "o")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)