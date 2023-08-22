(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{28}compatible\u{3b}[A-Z]*\u{3b}\u{29}\u{0d}\u{0a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/(compatible;") (re.* (re.range "A" "Z")) (str.to_re ";)\u{0d}\u{0a}/H\u{0a}")))))
; ^(([0-9]{5})|([0-9]{3}[ ]{0,1}[0-9]{2}))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
