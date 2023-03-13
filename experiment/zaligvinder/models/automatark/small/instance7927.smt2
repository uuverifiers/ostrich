(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; href[\s]*=[\s]*"[^\n"]*"
(assert (str.in_re X (re.++ (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}"))))
; ^([a-zA-Z0-9])+\\{1}([a-zA-Z0-9])+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
