(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ';([dmstrl])([ .,?!\)\\/<])
(assert (not (str.in_re X (re.++ (str.to_re "';") (re.union (str.to_re "d") (str.to_re "m") (str.to_re "s") (str.to_re "t") (str.to_re "r") (str.to_re "l")) (re.union (str.to_re " ") (str.to_re ".") (str.to_re ",") (str.to_re "?") (str.to_re "!") (str.to_re ")") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "<")) (str.to_re "\u{0a}")))))
; User-Agent\x3AreadyHost\x3AHost\x3ASubject\x3Awininetproducts
(assert (not (str.in_re X (str.to_re "User-Agent:readyHost:Host:Subject:wininetproducts\u{0a}"))))
; ^0[234679]{1}[\s]{0,1}[\-]{0,1}[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
