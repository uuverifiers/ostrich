(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[A-Za-z0-9+~=]{16,17}\u{2f}[A-Za-z0-9+~=]{35,40}\u{2f}[A-Za-z0-9+~=]{8}\u{2f}[A-Za-z0-9+~=]*?\u{2f}[A-Za-z0-9+~=]{12,30}$/I
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 16 17) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 35 40) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 12 30) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/I\u{0a}")))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}")))))
; LIST\]SpamBlockerUtilityTry2FindBasicHost\x3AUser-Agent\x3AAcmeprotocolSpy
(assert (str.in_re X (str.to_re "LIST]SpamBlockerUtilityTry2FindBasicHost:User-Agent:AcmeprotocolSpy\u{0a}")))
; ^[\\(]{0,1}[0-9]{3}([\\)]{0,1}|-|\s){0,1}[0-9]{3}(-|\s){0,1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "\u{5c}") (str.to_re "("))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (re.opt (re.union (str.to_re "\u{5c}") (str.to_re ")"))) (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Subject\x3A\.bmpfromemail=couponbar\.coupons\.comToolbarxml\.alexa\.com
(assert (str.in_re X (str.to_re "Subject:.bmpfromemail=couponbar.coupons.comToolbarxml.alexa.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
