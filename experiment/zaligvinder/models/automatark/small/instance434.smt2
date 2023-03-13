(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+{1}|00)\s{0,1}([0-9]{3}|[0-9]{2})\s{0,1}\-{0,1}\s{0,1}([0-9]{2}|[1-9]{1})\s{0,1}\-{0,1}\s{0,1}([0-9]{8}|[0-9]{7})
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "00")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}")))))
; www\x2Eemp3finder\x2Ecom\d+ZOMBIES\u{5f}HTTP\u{5f}GET
(assert (str.in_re X (re.++ (str.to_re "www.emp3finder.com") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GET\u{0a}"))))
(check-sat)
