(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?(\d{1,3}(\,\d{3})*|(\d+))(\.\d{0,2})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^([^\s]){5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}dae/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dae/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
