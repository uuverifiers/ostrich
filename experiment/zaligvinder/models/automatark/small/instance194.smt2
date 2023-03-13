(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\$)?(\s)?(\-)?((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{2,})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /(\u{17}\u{00}|\u{00}\x5C)\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{17}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
(check-sat)
