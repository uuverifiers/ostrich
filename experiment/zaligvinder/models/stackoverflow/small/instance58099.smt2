;test regex ^(((![A-Z0-9]{5})|([#+&][^\u{00}\u{07}\r\n ,:]+))(:[^\u{00}\u{07}\r\n ,:]+)?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "!") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.union (str.to_re "#") (re.union (str.to_re "+") (str.to_re "&"))) (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{00}")) (re.inter (re.diff re.allchar (str.to_re "\u{07}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re " ")) (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (str.to_re ":"))))))))))) (re.opt (re.++ (str.to_re ":") (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{00}")) (re.inter (re.diff re.allchar (str.to_re "\u{07}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re " ")) (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (str.to_re ":"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)