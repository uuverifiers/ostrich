(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([EV])?\d{3,3}(\.\d{1,2})?(, *([EV])?\d{3,3}(\.\d{1,2})?)*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (re.++ (str.to_re ",") (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; OVN\s+\x2APORT3\x2A\[DRIVEwww\.raxsearch\.com
(assert (str.in_re X (re.++ (str.to_re "OVN") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*[DRIVEwww.raxsearch.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
