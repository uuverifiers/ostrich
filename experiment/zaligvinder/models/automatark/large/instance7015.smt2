(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eezula\x2Ecom.*com[^\n\r]*SpyBuddy
(assert (str.in_re X (re.++ (str.to_re "www.ezula.com") (re.* re.allchar) (str.to_re "com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "SpyBuddy\u{0a}"))))
; /^\/\/?[a-z0-9_]{7,8}\/\??[0-9a-f]{60,68}[\u{3b}\u{2c}\d+]*$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.opt (str.to_re "/")) ((_ re.loop 7 8) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "/") (re.opt (str.to_re "?")) ((_ re.loop 60 68) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.* (re.union (str.to_re ";") (str.to_re ",") (re.range "0" "9") (str.to_re "+"))) (str.to_re "/U\u{0a}"))))
; /filename=[a-z]{5,8}\d{2,3}\.swf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".swf\u{0d}\u{0a}/Hm\u{0a}"))))
; actualnames\.comclient\x2Ebaigoo\x2Ecomzzzvmkituktgr\u{2f}etiexpsp2-InformationHost\x3A
(assert (str.in_re X (str.to_re "actualnames.comclient.baigoo.comzzzvmkituktgr/etiexpsp2-InformationHost:\u{0a}")))
(check-sat)
