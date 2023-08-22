(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[\u{28}\u{5b}][^\x3D]+?[\u{29}\u{5d}][^\x3D]*?\x3D/Cm
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "(") (str.to_re "[")) (re.+ (re.comp (str.to_re "="))) (re.union (str.to_re ")") (str.to_re "]")) (re.* (re.comp (str.to_re "="))) (str.to_re "=/Cm\u{0a}"))))
; ^[A-Za-z]{1}[0-9]{7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
