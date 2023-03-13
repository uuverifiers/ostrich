(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CZ\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|CZ\d{22}
(assert (not (str.in_re X (re.++ (str.to_re "CZ") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}")))))))
; TSA\x2FS\u{3a}Users\u{5c}http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "TSA/S:Users\u{5c}http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
; User-Agent\x3ASurveillancecomOnline
(assert (not (str.in_re X (str.to_re "User-Agent:Surveillance\u{13}comOnline\u{0a}"))))
; \$?GP[a-z]{3,},([a-z0-9\.]*,)+([a-z0-9]{1,2}\*[a-z0-9]{1,2})
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (str.to_re "GP,") (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "."))) (str.to_re ","))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "a" "z")) (re.* (re.range "a" "z")) ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "*") ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))))))
; /filename=[^\n]*\u{2e}aom/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aom/i\u{0a}")))))
(check-sat)
