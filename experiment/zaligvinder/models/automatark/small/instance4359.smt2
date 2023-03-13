(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (GB-?)?([1-9][0-9]{2}\ ?[0-9]{4}\ ?[0-9]{2})|([1-9][0-9]{2}\ ?[0-9]{4}\ ?[0-9]{2}\ ?[0-9]{3})|((GD|HA)[0-9]{3})
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "GB") (re.opt (str.to_re "-")))) (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "GD") (str.to_re "HA")) ((_ re.loop 3 3) (re.range "0" "9"))))))
; /\u{2e}asx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.asx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^\d{5}((\-|\s)?\d{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /gate\u{2e}php\u{3f}reg=[a-z]{10}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 10 10) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
; client\x2Ebaigoo\x2Ecom\s+ised2k
(assert (not (str.in_re X (re.++ (str.to_re "client.baigoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ised2k\u{0a}")))))
(check-sat)
