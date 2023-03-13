(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; gpstool\u{2e}globaladserver\u{2e}com\daction\x2E\w+data2\.activshopper\.com
(assert (not (str.in_re X (re.++ (str.to_re "gpstool.globaladserver.com") (re.range "0" "9") (str.to_re "action.") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.com\u{0a}")))))
; xpsp2-\s+spyblpatHost\x3Ais\x2EphpBarFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "xpsp2-") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.phpBarFrom:\u{0a}"))))
; \$?GP[a-z]{3,},([a-z0-9\.]*,)+([a-z0-9]{1,2}\*[a-z0-9]{1,2})
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (str.to_re "GP,") (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "."))) (str.to_re ","))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "a" "z")) (re.* (re.range "a" "z")) ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "*") ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))))))
; ^((\+)?(\d{2}[-]))?(\d{10}){1}?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 1 1) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
