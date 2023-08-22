(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}"))))
; hirmvtg\u{2f}ggqh\.kqh\w+whenu\x2Ecom\w+weatherHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "weatherHost:User-Agent:\u{0a}"))))
; ^([0-9]{6}[\s\-]{1}[0-9]{12}|[0-9]{18})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 12 12) (re.range "0" "9"))) ((_ re.loop 18 18) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\w+www\x2Etopadwarereviews\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}"))))
; User-Agent\x3A\dBarwww\x2Eaccoona\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.range "0" "9") (str.to_re "Barwww.accoona.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
