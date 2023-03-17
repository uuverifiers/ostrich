;test regex (=?.{8,24})((:?[a-z]+)(:?[0-9]+)(:?[A-Z]+)(:?\W+))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (str.to_re "=")) ((_ re.loop 8 24) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.++ (re.opt (str.to_re ":")) (re.+ (re.range "a" "z"))) (re.++ (re.++ (re.opt (str.to_re ":")) (re.+ (re.range "0" "9"))) (re.++ (re.++ (re.opt (str.to_re ":")) (re.+ (re.range "A" "Z"))) (re.++ (re.opt (str.to_re ":")) (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)