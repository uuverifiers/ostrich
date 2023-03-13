(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(GIR\\s{0,1}0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\\s{0,1}[0-9][ABD-HJLNP-UW-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "GIR\u{5c}") (re.opt (str.to_re "s")) (str.to_re "0AA")) (re.++ (re.union (re.range "A" "P") (re.range "R" "U") (str.to_re "W") (str.to_re "Y") (str.to_re "Z")) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.range "0" "9") (re.union (re.range "0" "9") (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (re.range "V" "Y"))) (re.++ (re.range "0" "9") (re.union (re.range "A" "H") (str.to_re "J") (str.to_re "K") (re.range "S" "U") (str.to_re "W")))) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (str.to_re "N") (re.range "P" "U") (re.range "W" "Z"))))) (str.to_re "\u{0a}")))))
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
; User-Agent\u{3a}\s+Subject\x3Aas\x2Estarware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:as.starware.com\u{0a}"))))
; /\x2Fevil\x2Fservices\x2Fbid_register\x2Ephp\x3FBID\x3D[A-Za-z]{6}\u{26}IP\x3D\d{1,3}\x2E\d{1,3}\x2E\d{1,3}\x2E\d{1,3}\u{26}cipher\x3D[A-Za-z]{9}/smiU
(assert (str.in_re X (re.++ (str.to_re "//evil/services/bid_register.php?BID=") ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "&IP=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&cipher=") ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "/smiU\u{0a}"))))
(check-sat)
