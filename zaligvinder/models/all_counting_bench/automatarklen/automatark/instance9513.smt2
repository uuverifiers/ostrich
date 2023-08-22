(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z]{2})|([sS][^dasDAS]))$
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union ((_ re.loop 2 2) (re.union (re.range "a" "r") (re.range "t" "z") (re.range "A" "R") (re.range "T" "Z"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "d") (str.to_re "a") (str.to_re "s") (str.to_re "D") (str.to_re "A") (str.to_re "S")))) (str.to_re "\u{0a}")))))
; Cookie\u{3a}.*Host\x3A.*ldap\x3A\x2F\x2F
(assert (str.in_re X (re.++ (str.to_re "Cookie:") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "ldap://\u{0a}"))))
; ^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])(\D?([01]\d|2[0-3])\D?([0-5]\d)\D?([0-5]\d)?)?$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.++ (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.++ (re.range "0" "5") (re.range "0" "9"))) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
