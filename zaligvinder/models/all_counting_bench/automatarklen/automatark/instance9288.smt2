(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1-9]\d{0,2}(\,\d{3})*|([1-9]\d*))(\.\d{2})?)|([0]\.(([0][1-9])|([1-9]\d)))$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}0.") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))))))))
; ^\(?082|083|084|072\)?[\s-]?[\d]{3}[\s-]?[\d]{4}$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "(")) (str.to_re "082")) (str.to_re "083") (str.to_re "084") (re.++ (str.to_re "072") (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
