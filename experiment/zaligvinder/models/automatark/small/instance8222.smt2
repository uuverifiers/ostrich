(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; at\w+Pre\s+adfsgecoiwnfhirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (str.in_re X (re.++ (str.to_re "at") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
; (^[0-9]{1,8}|(^[0-9]{1,8}\.{0,1}[0-9]{1,2}))$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 8) (re.range "0" "9")) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
