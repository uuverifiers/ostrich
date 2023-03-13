(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[9]9\d{10}|^[5]\d{10}
(assert (str.in_re X (re.union (re.++ (str.to_re "99") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "5") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; hirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (not (str.in_re X (str.to_re "hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
; SpyAgent\d+sErver\s+User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.range "0" "9")) (str.to_re "sErver") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; X-Mailer\u{3a}.*User-Agent\x3A[^\n\r]*ulmxct\u{2f}mqoyc
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* re.allchar) (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoyc\u{0a}"))))
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9"))))))
(check-sat)
