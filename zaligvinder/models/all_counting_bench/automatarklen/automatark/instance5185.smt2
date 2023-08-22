(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Remote\x3Cchat\x3EX-Mailer\u{3a}www\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (str.to_re "Remote<chat>\u{1b}X-Mailer:\u{13}www.proventactics.com\u{0a}"))))
; ^(\$?)((\d{1,20})|(\d{1,2}((,?\d{3}){0,6}))|(\d{3}((,?\d{3}){0,5})))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union ((_ re.loop 1 20) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 0 6) (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 5) (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Pre\x2Fta\x2FNEWS\x2FKeyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre/ta/NEWS/Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}"))))
; ^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.union (str.to_re ":") (str.to_re "-")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; /\u{2e}mswmm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.mswmm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
