(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; phpinfo[^\n\r]*195\.225\.\dccecaedbebfcaf\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "phpinfo") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "195.225.") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}")))))
(check-sat)
