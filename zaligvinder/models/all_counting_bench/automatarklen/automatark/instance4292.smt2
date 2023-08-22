(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{0,5}|[0-9]{0,5}\.[0-9]{0,3})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 0 5) (re.range "0" "9")) (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pmd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pmd/i\u{0a}"))))
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
