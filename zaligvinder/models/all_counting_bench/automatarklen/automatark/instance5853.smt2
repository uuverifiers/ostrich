(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-z0-9][a-z0-9_\.-]{0,}[a-z0-9]\.[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9][\.][cn]{2,4}
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 4) (re.union (str.to_re "c") (str.to_re "n"))) (str.to_re "\u{0a}"))))
; PcastPORT-config\x2E180solutions\x2Ecom
(assert (not (str.in_re X (str.to_re "PcastPORT-config.180solutions.com\u{0a}"))))
; phpinfo[^\n\r]*195\.225\.\dccecaedbebfcaf\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "phpinfo") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "195.225.") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
