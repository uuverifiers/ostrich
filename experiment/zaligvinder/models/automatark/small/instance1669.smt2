(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; Host\x3AHost\x3AUser-Agent\x3AServerad\x2Emokead\x2Ecom
(assert (str.in_re X (str.to_re "Host:Host:User-Agent:Serverad.mokead.com\u{0a}")))
; \|(http.*)\|(.*)$/ig
(assert (str.in_re X (re.++ (str.to_re "||") (re.* re.allchar) (str.to_re "/ig\u{0a}http") (re.* re.allchar))))
(check-sat)
