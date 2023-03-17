;test regex \S+_+(\d+.){3}\.xlsx
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}")))))))) (re.++ (re.+ (str.to_re "_")) (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.range "0" "9")) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re ".") (re.++ (str.to_re "x") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (str.to_re "x"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)