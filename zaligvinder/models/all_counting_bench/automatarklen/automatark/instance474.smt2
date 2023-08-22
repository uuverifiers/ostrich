(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d+\.\d+)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")))))
; ^100$|^\s*(\d{0,2})((\.|\,)(\d*))?\s*\%?\s*$
(assert (str.in_re X (re.union (str.to_re "100") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; .*[Pp]re[Ss\$]cr[iI1]pt.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "P") (str.to_re "p")) (str.to_re "re") (re.union (str.to_re "S") (str.to_re "s") (str.to_re "$")) (str.to_re "cr") (re.union (str.to_re "i") (str.to_re "I") (str.to_re "1")) (str.to_re "pt") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ^([0-7])*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "7")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
