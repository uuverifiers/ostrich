(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xls/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xls/i\u{0a}"))))
; ^\d{3}\s?\d{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \bfor\b.*[A-Za-z][<> ][\d]
(assert (str.in_re X (re.++ (str.to_re "for") (re.* re.allchar) (re.union (re.range "A" "Z") (re.range "a" "z")) (re.union (str.to_re "<") (str.to_re ">") (str.to_re " ")) (re.range "0" "9") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
