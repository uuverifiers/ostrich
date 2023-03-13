;test regex ^(?:( {4,}|\t+)(.+))$(?:(?:(?:\n?)( {4,}|\t+)(.+))*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.* (str.to_re " ")) ((_ re.loop 4 4) (str.to_re " "))) (re.+ (str.to_re "\u{09}"))) (re.+ (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "") (re.* (re.++ (re.opt (str.to_re "\u{0a}")) (re.++ (re.union (re.++ (re.* (str.to_re " ")) ((_ re.loop 4 4) (str.to_re " "))) (re.+ (str.to_re "\u{09}"))) (re.+ (re.diff re.allchar (str.to_re "\n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)