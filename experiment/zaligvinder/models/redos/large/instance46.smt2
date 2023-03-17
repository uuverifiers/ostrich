;test regex ^[nN][aA][mM][eE]=s*[^\r\n\u{3b}\u{20}\u{09}\u{0b}\u{2c}]{300}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.++ (re.union (str.to_re "m") (str.to_re "M")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (str.to_re "=") (re.++ (re.* (str.to_re "s")) ((_ re.loop 300 300) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{3b}")) (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.diff re.allchar (str.to_re "\u{2c}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)