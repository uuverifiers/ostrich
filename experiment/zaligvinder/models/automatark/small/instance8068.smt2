(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{1,4}\u{2e}html\u{3f}0\u{2e}[0-9]{15,}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re ".html?0./U\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
; /filename=[^\n]*\u{2e}doc/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".doc/i\u{0a}"))))
; (ES-?)?([0-9A-Z][0-9]{7}[A-Z])|([A-Z][0-9]{7}[0-9A-Z])
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "ES") (re.opt (str.to_re "-")))) (re.union (re.range "0" "9") (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) (re.range "A" "Z")) (re.++ (str.to_re "\u{0a}") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z")))))))
(check-sat)
