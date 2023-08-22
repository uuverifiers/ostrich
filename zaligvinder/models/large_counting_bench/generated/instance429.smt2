;test regex (.{1,78})(?: +|$)\n?|(.{78})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 78) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.+ (str.to_re " ")) (str.to_re "")) (re.opt (str.to_re "\u{0a}")))) ((_ re.loop 78 78) (re.diff re.allchar (str.to_re "\n"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)