(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xslt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xslt/i\u{0a}")))))
; ^[A-Z]{3}(\s)?[0-9]{4}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3Aupgrade\x2Eqsrch\x2Einfo
(assert (not (str.in_re X (str.to_re "User-Agent:upgrade.qsrch.info\u{0a}"))))
; is\w+gdvsotuqwsg\u{2f}dxt\.hd
(assert (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "gdvsotuqwsg/dxt.hd\u{0a}"))))
; ^[^iIoOqQ'-]{10,17}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 17) (re.union (str.to_re "i") (str.to_re "I") (str.to_re "o") (str.to_re "O") (str.to_re "q") (str.to_re "Q") (str.to_re "'") (str.to_re "-"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
