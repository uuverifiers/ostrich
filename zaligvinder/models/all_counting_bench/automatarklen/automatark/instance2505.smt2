(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0(6[045679][0469]){1}(\-)?(1)?[^0\D]{1}\d{6}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.++ (str.to_re "6") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "6") (str.to_re "9")))) (re.opt (str.to_re "-")) (re.opt (str.to_re "1")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (^\d*\.\d{2}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
; .*[Pp]re[Ss\$]cr[iI1]pt.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "P") (str.to_re "p")) (str.to_re "re") (re.union (str.to_re "S") (str.to_re "s") (str.to_re "$")) (str.to_re "cr") (re.union (str.to_re "i") (str.to_re "I") (str.to_re "1")) (str.to_re "pt") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ^([0-9]{1,2},([0-9]{2},)*[0-9]{3}|[0-9]+)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(s-|S-){0,1}[0-9]{3}\s?[0-9]{2}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "s-") (str.to_re "S-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
