(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}\s+Host\x3AnamediepluginHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:namediepluginHost:X-Mailer:\u{13}\u{0a}")))))
; PASSW=\s+\x2Fta\x2FNEWS\x2F.*loomcompany\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/") (re.* re.allchar) (str.to_re "loomcompany.com\u{0a}"))))
; (CZ-?)?[0-9]{8,10}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "CZ") (re.opt (str.to_re "-")))) ((_ re.loop 8 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; log\=\x7BIP\x3A\s+Pcast\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\nHost\x3AHWAEname\u{2e}cnnic\u{2e}cnRXnewads1\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "log={IP:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}Host:HWAEname.cnnic.cnRXnewads1.com\u{0a}"))))
; /filename=[^\n]*\u{2e}m4r/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4r/i\u{0a}")))))
(check-sat)
