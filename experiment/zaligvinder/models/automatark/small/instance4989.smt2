(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /"(\\["\\]|[^"])*("|$)|(\\["\\]|[^\s"])+/g
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.++ (re.+ (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/g\u{0a}"))))))
; ^(GIR|[A-Z]\d[A-Z\d]?|[A-Z]{2}\d[A-Z\d]?)[ ]??(\d[A-Z]{0,2})??$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.range "0" "9") ((_ re.loop 0 2) (re.range "A" "Z")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}mny/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mny/i\u{0a}")))))
(check-sat)
