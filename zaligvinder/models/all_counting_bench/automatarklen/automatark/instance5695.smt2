(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[\u{28}\u{5b}][^\x3D]+?[\u{29}\u{5d}][^\x3D]*?\x3D/Cm
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "(") (str.to_re "[")) (re.+ (re.comp (str.to_re "="))) (re.union (str.to_re ")") (str.to_re "]")) (re.* (re.comp (str.to_re "="))) (str.to_re "=/Cm\u{0a}")))))
; ^([1-9]{0,1})([0-9]{1})(\.[0-9])?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.opt (str.to_re "-")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}") (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
