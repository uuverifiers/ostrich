(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\$\s*[\d,]+\.\d{2})\b
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
