(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; MyPostsearch\u{2e}conduit\u{2e}comUser-Agent\x3AAcmeSubject\x3Aready\.\r\n
(assert (not (str.in_re X (str.to_re "MyPostsearch.conduit.comUser-Agent:AcmeSubject:ready.\u{0d}\u{0a}\u{0a}"))))
; media\x2Edxcdirect\x2Ecom\.smx\?PASSW=SAHHost\x3AProAgentIDENTIFY
(assert (not (str.in_re X (str.to_re "media.dxcdirect.com.smx?PASSW=SAHHost:ProAgentIDENTIFY\u{0a}"))))
; ^0?[0-9]?[0-9]$|^(100)$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) (re.opt (re.range "0" "9")) (re.range "0" "9")) (str.to_re "100\u{0a}")))))
; Servidor\x2Ehome\x2Eedonkey\x2Ecom
(assert (not (str.in_re X (str.to_re "Servidor.\u{13}home.edonkey.com\u{0a}"))))
; /^\/images2\/[0-9a-fA-F]{500,}/U
(assert (str.in_re X (re.++ (str.to_re "//images2//U\u{0a}") ((_ re.loop 500 500) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))
(assert (> (str.len X) 10))
(check-sat)
