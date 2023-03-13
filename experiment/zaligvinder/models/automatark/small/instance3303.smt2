(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [^"]+
(assert (str.in_re X (re.++ (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
; ^[1-9]{1}[0-9]{0,2}([\.\,]?[0-9]{3})*$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
(assert (not (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
