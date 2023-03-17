;test regex \"&?$string:?(\\\\\\\\t)?\".{1,7}$lang=\"&?(.*?):?\"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.opt (str.to_re "&"))) (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (re.opt (str.to_re ":")) (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (str.to_re "t")))))) (re.++ (str.to_re "\u{22}") ((_ re.loop 1 7) (re.diff re.allchar (str.to_re "\n")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (str.to_re "&")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re ":")) (str.to_re "\u{22}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)