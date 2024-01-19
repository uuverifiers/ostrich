(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[\u{28}\u{5b}][^\x3D]+?[\u{29}\u{5d}][^\x3D]*?\x3D/Cm
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "(") (str.to_re "[")) (re.+ (re.comp (str.to_re "="))) (re.union (str.to_re ")") (str.to_re "]")) (re.* (re.comp (str.to_re "="))) (str.to_re "=/Cm\u{0a}")))))
; ^[a-zA-Z]\w{0,30}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
