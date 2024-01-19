(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{1,4}\u{2e}html\u{3f}0\u{2e}[0-9]{15,}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re ".html?0./U\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
; ^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
