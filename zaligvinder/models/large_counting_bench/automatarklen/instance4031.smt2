(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3001[0-9A-F]{262,304}/
(assert (str.in_re X (re.++ (str.to_re "//3001") ((_ re.loop 262 304) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/\u{0a}"))))
; ^\+?\(?\d+\)?(\s|\-|\.)?\d{1,3}(\s|\-|\.)?\d{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "(")) (re.+ (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\.php\u{3f}w\u{3d}\d+\u{26}n\u{3d}\d+/U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?w=") (re.+ (re.range "0" "9")) (str.to_re "&n=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
