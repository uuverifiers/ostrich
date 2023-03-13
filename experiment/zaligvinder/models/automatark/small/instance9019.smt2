(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\+?([1-8])?\d(\.\d+)?$)|(^-90$)|(^-(([1-8])?\d(\.\d+)?$))
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (re.opt (re.range "1" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "-90") (re.++ (str.to_re "\u{0a}-") (re.opt (re.range "1" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))
; ^([1-9]([0-9])?)(\.(([0])?|([1-9])?|[1]([0-1])?)?)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re ".") (re.opt (re.union (re.opt (str.to_re "0")) (re.opt (re.range "1" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "1"))))))) (str.to_re "\u{0a}") (re.range "1" "9") (re.opt (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}xslt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xslt/i\u{0a}"))))
; ^((ht|f)tp(s?))\://([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(/\S*)?$
(assert (str.in_re X (re.++ (str.to_re "://") (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))))
(check-sat)
