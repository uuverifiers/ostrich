(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([oO0]*)([|:;=X^])([-']*)([)(oO0\]\[DPp*>X^@])
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "o") (str.to_re "O") (str.to_re "0"))) (re.union (str.to_re "|") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "X") (str.to_re "^")) (re.* (re.union (str.to_re "-") (str.to_re "'"))) (re.union (str.to_re ")") (str.to_re "(") (str.to_re "o") (str.to_re "O") (str.to_re "0") (str.to_re "]") (str.to_re "[") (str.to_re "D") (str.to_re "P") (str.to_re "p") (str.to_re "*") (str.to_re ">") (str.to_re "X") (str.to_re "^") (str.to_re "@")) (str.to_re "\u{0a}")))))
; ^([A-Z0-9]{5})$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^([a-zA-Z0-9][a-zA-Z0-9_]*(\.{0,1})?[a-zA-Z0-9\-_]+)*(\.{0,1})@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|([a-zA-Z0-9\-]+(\.([a-zA-Z]{2,10}))(\.([a-zA-Z]{2,10}))?(\.([a-zA-Z]{2,10}))?))[\s]*$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.opt (re.opt (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))))) (re.opt (str.to_re ".")) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; /\u{2e}pfa([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pfa") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
