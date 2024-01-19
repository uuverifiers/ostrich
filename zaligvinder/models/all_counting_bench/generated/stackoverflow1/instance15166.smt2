;test regex m{1,}e{1,}r{1,}d{1,}a{1,}s{1,}|m{1,}e{1,}r{1,}d{1,}a{1,}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.* (str.to_re "m")) ((_ re.loop 1 1) (str.to_re "m"))) (re.++ (re.++ (re.* (str.to_re "e")) ((_ re.loop 1 1) (str.to_re "e"))) (re.++ (re.++ (re.* (str.to_re "r")) ((_ re.loop 1 1) (str.to_re "r"))) (re.++ (re.++ (re.* (str.to_re "d")) ((_ re.loop 1 1) (str.to_re "d"))) (re.++ (re.++ (re.* (str.to_re "a")) ((_ re.loop 1 1) (str.to_re "a"))) (re.++ (re.* (str.to_re "s")) ((_ re.loop 1 1) (str.to_re "s")))))))) (re.++ (re.++ (re.* (str.to_re "m")) ((_ re.loop 1 1) (str.to_re "m"))) (re.++ (re.++ (re.* (str.to_re "e")) ((_ re.loop 1 1) (str.to_re "e"))) (re.++ (re.++ (re.* (str.to_re "r")) ((_ re.loop 1 1) (str.to_re "r"))) (re.++ (re.++ (re.* (str.to_re "d")) ((_ re.loop 1 1) (str.to_re "d"))) (re.++ (re.* (str.to_re "a")) ((_ re.loop 1 1) (str.to_re "a"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)