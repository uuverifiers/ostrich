(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{3}P[A-Z][0-9]{7}[0-9X]
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "P") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Pre\x2Fta\x2FNEWS\x2FKeyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre/ta/NEWS/Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}"))))
; attachedEverywareHELOBasic
(assert (str.in_re X (str.to_re "attachedEverywareHELOBasic\u{0a}")))
; ^\(?([0-9]{3})\)?[\s\.\-]*([0-9]{3})[\s\.\-]*([0-9]{4})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.* (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
