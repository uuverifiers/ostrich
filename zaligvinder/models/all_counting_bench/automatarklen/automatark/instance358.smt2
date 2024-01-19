(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}.*UNSEEN\u{22}\s+Agentbody=\u{25}21\u{25}21\u{25}21Optix
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "UNSEEN\u{22}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Agentbody=%21%21%21Optix\u{13}\u{0a}")))))
; media\x2Etop-banners\x2Ecom
(assert (str.in_re X (str.to_re "media.top-banners.com\u{0a}")))
; /\/ddd\/[a-z]{2}.gif/iU
(assert (str.in_re X (re.++ (str.to_re "//ddd/") ((_ re.loop 2 2) (re.range "a" "z")) re.allchar (str.to_re "gif/iU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
