(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [\t ]+
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "\u{09}") (str.to_re " "))) (str.to_re "\u{0a}"))))
; ^[A-Z]{5}[0-9]{4}[A-Z]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "A" "Z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; ([^\\"]|\\.)*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{5c}") (str.to_re "\u{22}"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
