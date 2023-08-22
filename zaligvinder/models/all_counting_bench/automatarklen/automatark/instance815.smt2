(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/modules\/\d\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//modules/") (re.range "0" "9") (str.to_re ".jar/U\u{0a}"))))
; /^Content-Disposition\x3A\s*attachment/smi
(assert (str.in_re X (re.++ (str.to_re "/Content-Disposition:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "attachment/smi\u{0a}"))))
; ^\{[A-Fa-f\d]{8}-[A-Fa-f\d]{4}-[A-Fa-f0\d]{4}-[A-Fa-f\d]{4}-[A-Fa-f\d]{12}\}$
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (str.to_re "0") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "}\u{0a}")))))
; ^(\d{1}|\d{2}|\d{3})(\.\d{3})*?$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; var phonePattern = /^(([^\.\-\,a-wy-z]([\(]?(\+|[x])?\d+[\)]?)?[\s\.\-\,]?([\(]?\d+[\)]?)?[\s\.\-\,]?(\d+[\s\.\-\,]?)+[^\.\-\,a-z])|((\+|[x])?\d+))$/i
(assert (str.in_re X (re.++ (str.to_re "var phonePattern = /") (re.union (re.++ (re.union (str.to_re ".") (str.to_re "-") (str.to_re ",") (re.range "a" "w") (re.range "y" "z")) (re.opt (re.++ (re.opt (str.to_re "(")) (re.opt (re.union (str.to_re "+") (str.to_re "x"))) (re.+ (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.opt (str.to_re "(")) (re.+ (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.union (str.to_re ".") (str.to_re "-") (str.to_re ",") (re.range "a" "z"))) (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "x"))) (re.+ (re.range "0" "9")))) (str.to_re "/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
