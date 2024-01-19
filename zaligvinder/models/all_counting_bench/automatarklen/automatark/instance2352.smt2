(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[$]?[0-9]*(\.)?[0-9]?[0-9]?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}docm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".docm/i\u{0a}")))))
; ^([a-zA-Z0-9]{6,18}?)$
(assert (not (str.in_re X (re.++ ((_ re.loop 6 18) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(\+?\d{1,2}[ -]?)?(\(\+?\d{2,3}\)|\+?\d{2,3})?[ -]?\d{3,4}[ -]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))))) (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")) (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 3) (re.range "0" "9"))))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
