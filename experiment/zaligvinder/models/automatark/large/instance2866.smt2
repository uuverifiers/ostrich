(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}")))
; ^[0-9]%?$|^1[0-9]%?$|^2[0-9]%?$|^3[0-5]%?$|^[0-9]\.\d{1,2}%?$|^1[0-9]\.\d{1,2}%?$|^2[0-9]\.\d{1,2}%?$|^3[0-4]\.\d{1,2}%?$|^35%?$
(assert (str.in_re X (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "1") (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "2") (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "3") (re.range "0" "5") (re.opt (str.to_re "%"))) (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "1") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "2") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "3") (re.range "0" "4") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "35") (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; cs\x2Eshopperreports\x2EcomActivityHost\x3AYeah\!User-Agent\x3AMicrosoft
(assert (not (str.in_re X (str.to_re "cs.shopperreports.comActivityHost:Yeah!User-Agent:Microsoft\u{0a}"))))
; /filename=[^\n]*\u{2e}xbm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xbm/i\u{0a}"))))
; /^\u{2f}[A-Za-z0-9+~=]{16,17}\u{2f}[A-Za-z0-9+~=]{35,40}\u{2f}[A-Za-z0-9+~=]{8}\u{2f}[A-Za-z0-9+~=]*?\u{2f}[A-Za-z0-9+~=]{12,30}$/I
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 16 17) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 35 40) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 12 30) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/I\u{0a}"))))
(check-sat)
