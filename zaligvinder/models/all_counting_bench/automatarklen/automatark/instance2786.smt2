(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wowokay\d+FTP\s+Host\x3AFiltered\u{22}reaction\x2Etxt\u{22}
(assert (not (str.in_re X (re.++ (str.to_re "wowokay") (re.+ (re.range "0" "9")) (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Filtered\u{22}reaction.txt\u{22}\u{0a}")))))
; ProAgent\d+X-Mailer\x3Abacktrust\x2EcomReferer\u{3a}Supreme
(assert (str.in_re X (re.++ (str.to_re "ProAgent") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}backtrust.comReferer:Supreme\u{0a}"))))
; X-Mailer\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}User-Agent:\u{0a}"))))
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
(assert (> (str.len X) 10))
(check-sat)
