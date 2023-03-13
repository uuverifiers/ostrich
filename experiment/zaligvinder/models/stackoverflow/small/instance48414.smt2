;test regex $pattern = "/<a[^\u{3e}]{0,}href=\u{22}([^\u{22}]*)\u{22}>([^\u{3c}]*)<\/a>/";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\u{3e}"))) ((_ re.loop 0 0) (re.diff re.allchar (str.to_re "\u{3e}")))) (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{3c}"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re ">") (re.++ (str.to_re "/") (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)