(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Minutes\s+\x2Fcgi\x2Flogurl\.cgi\s+e2give\.com
(assert (str.in_re X (re.++ (str.to_re "Minutes") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com\u{0a}"))))
; www\.actualnames\.com\s+toolbar_domain_redirect\s+Contactfrom=GhostVoiceServer
(assert (not (str.in_re X (re.++ (str.to_re "www.actualnames.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "toolbar_domain_redirect") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Contactfrom=GhostVoiceServer\u{0a}")))))
; Host\x3AHost\x3AFrom\u{3a}\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo\u{2f}zowy
(assert (str.in_re X (str.to_re "Host:Host:From:\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo/zowy\u{0a}")))
; ^([GB])*(([1-9]\d{8})|([1-9]\d{11}))$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "G") (str.to_re "B"))) (re.union (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 11 11) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
