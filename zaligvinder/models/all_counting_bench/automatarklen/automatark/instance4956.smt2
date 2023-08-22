(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*-?(\d{0,7}|10[0-5]\d{0,5}|106[0-6]\d{0,4}|1067[0-4]\d{0,3}|10675[0-1]\d{0,2}|((\d{0,7}|10[0-5]\d{0,5}|106[0-6]\d{0,4}|1067[0-4]\d{0,3}|10675[0-1]\d{0,2})\.)?([0-1]?[0-9]|2[0-3]):[0-5]?[0-9](:[0-5]?[0-9](\.\d{1,7})?)?)\s*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.union ((_ re.loop 0 7) (re.range "0" "9")) (re.++ (str.to_re "10") (re.range "0" "5") ((_ re.loop 0 5) (re.range "0" "9"))) (re.++ (str.to_re "106") (re.range "0" "6") ((_ re.loop 0 4) (re.range "0" "9"))) (re.++ (str.to_re "1067") (re.range "0" "4") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (str.to_re "10675") (re.range "0" "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.opt (re.++ (re.union ((_ re.loop 0 7) (re.range "0" "9")) (re.++ (str.to_re "10") (re.range "0" "5") ((_ re.loop 0 5) (re.range "0" "9"))) (re.++ (str.to_re "106") (re.range "0" "6") ((_ re.loop 0 4) (re.range "0" "9"))) (re.++ (str.to_re "1067") (re.range "0" "4") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (str.to_re "10675") (re.range "0" "1") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "."))) (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.opt (re.range "0" "5")) (re.range "0" "9") (re.opt (re.++ (str.to_re ":") (re.opt (re.range "0" "5")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 7) (re.range "0" "9")))))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; /^\s+$|^$/gi
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "/gi\u{0a}")))))
; $(\n|\r\n)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}\u{0a}")) (str.to_re "\u{0a}")))))
; ^[a-zA-Z_]{1}[a-zA-Z0-9_@$#]*$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re "$") (str.to_re "#"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
