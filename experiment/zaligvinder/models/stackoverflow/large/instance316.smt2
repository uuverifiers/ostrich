;test regex ^(([^\t]*\t){59}[^\t\xB6]*)\xB6
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 59 59) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{09}"))) (str.to_re "\u{09}"))) (re.* (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{b6}"))))) (str.to_re "\u{b6}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)