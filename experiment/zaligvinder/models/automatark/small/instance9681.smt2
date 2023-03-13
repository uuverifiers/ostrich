(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re " ") (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^([A-Z]{2}[\s]|[A-Z]{2})[\w]{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
(check-sat)
