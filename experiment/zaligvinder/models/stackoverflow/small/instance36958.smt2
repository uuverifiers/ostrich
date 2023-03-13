;test regex ^(?:.{1}|.{4}|.{7}|.{8})([A-Z])(?:.{0}|.{3}|.{6}|.{9}|.{10})([0-9])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 7 7) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.range "A" "Z") (re.++ (re.union (re.union (re.union (re.union ((_ re.loop 0 0) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 9 9) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 10 10) (re.diff re.allchar (str.to_re "\n")))) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)