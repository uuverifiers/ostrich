(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[oz]/Ri
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "o") (str.to_re "z")) (str.to_re "/Ri\u{0a}")))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}")))))
; actualnames\.comclient\x2Ebaigoo\x2Ecomzzzvmkituktgr\u{2f}etiexpsp2-InformationHost\x3A
(assert (not (str.in_re X (str.to_re "actualnames.comclient.baigoo.comzzzvmkituktgr/etiexpsp2-InformationHost:\u{0a}"))))
; /\u{2f}ib2\u{2f}$/U
(assert (str.in_re X (str.to_re "//ib2//U\u{0a}")))
; (0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") (re.union (str.to_re "2") (str.to_re "8") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "8") (str.to_re "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "8") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "290") (re.range "0" "9")) (re.++ (str.to_re "291") (re.range "0" "4")) (re.++ (str.to_re "7") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}7") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
