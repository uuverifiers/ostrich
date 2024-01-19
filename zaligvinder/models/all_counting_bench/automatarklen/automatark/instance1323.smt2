(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x3Fp\x3D[0-9]{1,10}\u{26}d\x3D/U
(assert (str.in_re X (re.++ (str.to_re "/?p=") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "&d=/U\u{0a}"))))
; zzzvmkituktgr\u{2f}etie\sHost\x3ASoftActivityYeah\!whenu\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "zzzvmkituktgr/etie") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:SoftActivity\u{13}Yeah!whenu.com\u{1b}\u{0a}"))))
; ad\x2Esearchsquire\x2Ecom[^\n\r]*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "ad.searchsquire.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
