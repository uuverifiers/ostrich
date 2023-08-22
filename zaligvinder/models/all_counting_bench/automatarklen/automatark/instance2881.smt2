(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\#?[A-Fa-f0-9]{3}([A-Fa-f0-9]{3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\+)?([9]{1}[2]{1})?-? ?(\()?([0]{1})?[1-9]{2,4}(\))?-? ??(\()?[1-9]{4,7}(\))?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (str.to_re "2")))) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 2 4) (re.range "1" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 4 7) (re.range "1" "9")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}")))))
; ^[1-9]{1}[0-9]{3} ?[A-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}xfdl/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xfdl/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
