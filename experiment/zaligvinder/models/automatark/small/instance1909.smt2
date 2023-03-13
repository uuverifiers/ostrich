(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; mywayHost\x3Awww\x2Eeblocs\x2Ecom
(assert (not (str.in_re X (str.to_re "mywayHost:www.eblocs.com\u{1b}\u{0a}"))))
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
; /filename=[^\n]*\u{2e}wm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wm/i\u{0a}")))))
; TPSystemHost\u{3a}\x7D\x7BUser\x3AAlert\x2Fcgi-bin\x2FX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "TPSystemHost:}{User:Alert/cgi-bin/X-Mailer:\u{13}\u{0a}"))))
(check-sat)
