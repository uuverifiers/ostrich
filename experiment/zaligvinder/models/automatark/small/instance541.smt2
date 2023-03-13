(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{5}((\-|\s)?\d{4})?$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Password="(\{.+\}[0-9a-zA-Z]+[=]*|[0-9a-zA-Z]+)"
(assert (not (str.in_re X (re.++ (str.to_re "Password=\u{22}") (re.union (re.++ (str.to_re "{") (re.+ re.allchar) (str.to_re "}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (str.to_re "="))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (str.to_re "\u{22}\u{0a}")))))
; <(\/{0,1})img(.*?)(\/{0,1})\>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.opt (str.to_re "/")) (str.to_re "img") (re.* re.allchar) (re.opt (str.to_re "/")) (str.to_re ">\u{0a}")))))
(check-sat)
