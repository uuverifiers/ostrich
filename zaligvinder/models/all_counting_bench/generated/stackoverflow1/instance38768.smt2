;test regex ^(220)(250)((334){2}(235))?(250){2,}(354)(250)(221)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "220") (re.++ (str.to_re "250") (re.++ (re.opt (re.++ ((_ re.loop 2 2) (str.to_re "334")) (str.to_re "235"))) (re.++ (re.++ (re.* (str.to_re "250")) ((_ re.loop 2 2) (str.to_re "250"))) (re.++ (str.to_re "354") (re.++ (str.to_re "250") (str.to_re "221")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)