(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Controlsource%3Dultrasearch136%26campaign%3Dsnap
(assert (not (str.in_re X (str.to_re "Controlsource%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; ^[^a-zA-Z0-9]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ((IT|LV)-?)?[0-9]{11}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
