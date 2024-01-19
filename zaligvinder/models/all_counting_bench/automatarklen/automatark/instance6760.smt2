(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Esogou\x2Ecomix=WebsiteHost\u{3a}Web-Mail
(assert (str.in_re X (str.to_re "www.sogou.comix=WebsiteHost:Web-Mail\u{0a}")))
; ^R(\d){8}
(assert (str.in_re X (re.++ (str.to_re "R") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wvx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wvx/i\u{0a}")))))
; ^[0-9]*[1-9]+[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
